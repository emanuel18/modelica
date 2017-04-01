package Util;

use strict;
use warnings;
use Data::Dumper;
use Graph::Undirected;
use Scalar::Util 'looks_like_number';  
use Exporter qw(import);
our @EXPORT_OK = qw( find_variable_in_graph );
use constant DEBUG => 0;
our %EXPORT_TAGS = (
    'all' => \@EXPORT_OK,
);

# my $graph1  = {
        #   'ran' => '',
        #   'name' => 'a9,b9,fn,gn',
        #   'var_info' => {
        #                   'b' => [
        #                            9
        #                          ],
        #                   'a' => [
        #                            9
        #                          ]
        #                 },
        #   'equations' => [
        #                    'fn',
        #                    'gn'
        #                  ]
        # };
# our $graph = {
#           'index' => {
#                        'a' => 0,
#                        'b' => 0
#                      },
#           'name' => 'a1to9,b1to9,fi19,gi19',
#           'equations' => [
#                            'fi19',
#                            'gi19'
#                          ],
#           'var_info' => {
#                           'a' => '',
#                           'b' => ''
#                         },
#           'ran' => {
#                      'end' => 9,
#                      'next' => 1,
#                      'init' => 1,
#                      'vars' => [
#                                  'a',
#                                  'b'
#                                ]
#                    }
#         };
# &main;

# sub main {
#     my $val = find_variable_in_graph($graph,'c','9');
#     warn "val: $val\n";
# }


# quiero saber si la variable $variable con index: $index existe en el grafo $graph
sub find_variable_in_graph {
    my $graph = shift;
    my $variable = shift;
    my $index = shift;

    # warn "\tfind_variable_in_graph graph: " . Dumper($graph);
    # warn "\tfind_variable_in_graph variable: " . Dumper($variable);
    # warn "\tfind_variable_in_graph index: " . Dumper($index);

    my $var_info = $graph->{var_info};

    # el grafo tiene for y la info esta en rango
    if ($graph->{ran}) {
        # warn "\tfind_variable_in_graph graph->{ran}: " . Dumper($graph->{ran});
        my $exist_var_in_eq_ran = 0;
        # me fijo si la variable esta dentro de las variables que tiene el rango del for
        foreach my $v (@{$graph->{ran}->{vars}}) {
            if ($v eq $variable) {
                $exist_var_in_eq_ran = 1;
                last;
            }
        }
        # warn "exist_var_in_eq_ran:$exist_var_in_eq_ran\n";
        # debe tener indice xq estoy buscando en un grafo que tiene for
        # si busco c, no tiene indice y sale de aca retornando 0
        if ($exist_var_in_eq_ran && $index) {
            # print "find_variable_in_graph: " . Dumper($graph->{ran}) . "\n";
            # my $init = $graph->{ran}->{init}+$index;
            my $init = $graph->{ran}->{init};
            my $end  = $graph->{ran}->{end};
            # my $end  = $graph->{ran}->{end}+$index;
            # print "ARRAY ". Dumper($graph->{ran}) . "\n";
            my $min = ($init < $end ? $init : $end);
            my $max = ($init > $end ? $init : $end);
            # print "min: $min max: $max index:$index\n";

            if ($index >= $min && $index <= $max) {
                # print "$index >= $min $index <= $max\n";
                return 1;
            } 
        }
    }
    # warn "\tfind_variable_in_graph var_info: " . Dumper($var_info);
    # el grafo no tiene for la info esta las variables
    # print "ref var_info: " . ref $var_info;
    elsif ($graph->{ran} eq '') {
        # warn "\tfind_variable_in_graph variable:$variable index:$index var_info: " . Dumper($var_info);
        foreach my $var (keys %{$var_info}) {
            if ($var eq $variable) {
                my $var_info_var = $var_info->{$var};
                # el caso de c no tiene indice
                # debo chequear que var_info de la variable no tenga indice
                unless ($index) {
                    if(@{$var_info_var}) {
                        return 0;
                    }
                    else {
                        return 1;
                    }
                }

                foreach my $ar (@{$var_info_var}) {
                    # print "HASH ar $ar index $index\n";
                    if ($ar eq $index) {
                        return 1;
                    }
                }
            }

        }
    }
    else {
        die "ERROR";
    }

    return 0;
}

1;