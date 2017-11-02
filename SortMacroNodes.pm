package SortMacroNodes;

use strict;
use warnings;
use Data::Dumper;
use Graph::Undirected;
use constant M => 10;
use constant N => 10;
use constant PRINT => 0;
use constant DELIMITER => ' -> ';
use BuildGraph qw(:build_graph);
use Util qw(:all);
use Array::Utils qw(:all);
use Params::Validate qw(:all);

use Exporter qw(import);
our @EXPORT_OK = qw( sort_macro_nodes DELIMITER );
our %EXPORT_TAGS = (
    'all' => \@EXPORT_OK,
);

# tengo todos los macronodos, c/u tiene informacion sobre como debe resolverse y tambien
# tiene informacion sobre cuales variables deben resolverse en otro macronodo. 
# Voy procesando c/u de los macronodos y mirando cuales son las variables que deben resolverse
# en otro mn, y me fijo cual o cuales(en caso de estar dentro de un for)
# son los otros macronodo en donde debe resolverse la variable

sub sort_macro_nodes {
    my %args = validate(
        @_,
        {
            macro_nodes  => 1,
        }
    );
    my $macro_nodes = $args{macro_nodes};
    my @order = ();

    foreach my $node_to_be_ordered (@{$macro_nodes}) {

        foreach my $eq (keys %{$node_to_be_ordered->{var_solved_in_other_mn}}) {
            print "####################  Analizando eq: $eq \n" if (PRINT);

            foreach my $var (keys %{$node_to_be_ordered->{var_solved_in_other_mn}->{$eq}}) {
                print "####################  Analizando var: $var \n" if (PRINT);
                # la variable esta dentro de un for
                my $var_solved_ran = $node_to_be_ordered->{var_solved_in_other_mn}->{$eq}->{$var}->{ran};

                if(keys %{$var_solved_ran}){

                    foreach my $index (keys %{$var_solved_ran}) {

                      my $init = $var_solved_ran->{$index}->{init};
                      my $end = $var_solved_ran->{$index}->{end};

                      if ($init > $end) {
                          my $tmp = $init;
                          $init   = $end;
                          $end    = $tmp;
                      }

                      foreach my $other_mn (@{$macro_nodes}) {
                          next if ($node_to_be_ordered eq $other_mn);
                          
                          # me fijo si el otro macronodo esta dentro de un for
                          print "####################  init:$init end:$end  \n" if (PRINT);
                          print "####################  other_mn: " . Dumper($other_mn) if (PRINT);

                          if(keys %{$other_mn->{ran}}) {
                              my $exists = 0;
                              # me fijo si la variable esta dentro de dicho for
                              foreach my $v (@{$other_mn->{ran}->{vars}}) {
                                  if ($v eq $var) {
                                      $exists = 1;
                                      last;
                                  }
                              }
                              next unless($exists);

                              my $init_other_mn = $other_mn->{ran}->{init};
                              my $end_other_mn  = $other_mn->{ran}->{end};

                              if ($init_other_mn > $end_other_mn) {
                                  my $tmp        = $init_other_mn;
                                  $init_other_mn = $end_other_mn;
                                  $end_other_mn  = $tmp;
                              }
                              if(
                                ($init < $init_other_mn and $init_other_mn < $end) or 
                                ($init < $end_other_mn and $end_other_mn < $end) or 
                                ($init <= $init_other_mn and $end_other_mn <= $end)
                              ){
                                  push @order, $node_to_be_ordered->{name} . DELIMITER . $other_mn->{name};
                                  # push @order, {$node_to_be_ordered->{name} => $other_mn->{name}};
                                  print "\t" . $node_to_be_ordered->{name} . " debe resolverse ante de $var -> " . $other_mn->{name}. "\n" if (PRINT);
                              }

                          }
                          else {
                              my @indices = ();

                              if (keys %{$other_mn->{var_info}} && $other_mn->{var_info}->{$var}) {
                                  @indices = @{$other_mn->{var_info}->{$var}};
                              }
                              if(@indices) {
                                  foreach my $index (@indices) {
                                      if(defined $index and ($init <= $index and $index <= $end)) {
                                          push @order, $node_to_be_ordered->{name} . DELIMITER . $other_mn->{name};
                                          # push @order, {$node_to_be_ordered->{name} => $other_mn->{name}};
                                          print "\t" . $node_to_be_ordered->{name} . " debe resolverse ante de $var -> " . $other_mn->{name}. "\n" if (PRINT);
                                          last;
                                      }
                                  }
                              }
                          }

                      }
                    }
                }
                
                my $var_constant = $node_to_be_ordered->{var_solved_in_other_mn}->{$eq}->{$var}->{constant};
                if(@{$var_constant}){

                    my @constant = @{$var_constant};

                    # es una constante como a[N]
                    foreach my $c (@constant) { 
                        foreach my $other_mn (@{$macro_nodes}) {
                            next if ($node_to_be_ordered eq $other_mn);
                               
                                if(find_variable_in_graph($other_mn,$var,$c)) {
                                    push @order, $node_to_be_ordered->{name} . DELIMITER . $other_mn->{name};
                                    # push @order, {$node_to_be_ordered->{name} => $other_mn->{name}};
                                    print "\t" . $node_to_be_ordered->{name} . " debe resolverse ante de $var($c) -> " . $other_mn->{name}. "\n" if (PRINT);
                                }
                        }
                    }
                    
                }
                # es una constante como C
                elsif (!@{$var_constant}){
                    foreach my $other_mn (@{$macro_nodes}) {
                        next if ($node_to_be_ordered eq $other_mn);

                        if(find_variable_in_graph($other_mn,$var)) {
                            push @order, $node_to_be_ordered->{name} . DELIMITER . $other_mn->{name};
                            # push @order, {$node_to_be_ordered->{name} => $other_mn->{name}};
                            print "\t" . $node_to_be_ordered->{name} . " debe resolverse ante de " . $other_mn->{name}. "\n" if (PRINT);
                        }
                    }
                }
            }
        }
    }
    return @order;
}

1;