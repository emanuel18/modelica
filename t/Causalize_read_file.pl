
use Data::Dumper;
use lib "/Users/emanuel/Documents/personal/facultad/causalize/5";

use strict;
use warnings;
use 5.010;
 
use Test::Simple;
use Test::More;
use constant N => 100;
use constant N_1 => 99;
use constant N_2 => 98;

use Causalize qw(causalize);

# Example 0
# a[N], b[N]
# for i in 2:N loop
#   a[i]*b[i]=8;          //fi
#   a[i]+b[i]*b[i-1]=20;  //gi
# end for;
#
# a[1]*b[1]=8;       //f1
# a[1]+b[1]=20;      //g1

our $data_example0 = {
    fi => {
        ran => { # rango del for
            0 => {
                init => 2,
                end  => N,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran      => "",
                constant => ""
            },
            b => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    gi => {
        ran => {
            0 => {
                init => 2,
                end  => N,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran      => "",
                constant => ""
            },
            b => {
                ran   => {
                    0 => {
                        init => 2,
                        end  => N,
                    },
                    -1 => {
                        init => 1,
                        end  => N-1,
                    }
                },
                constant => ""
            }
        }, 
    },
    f1 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [1]
            },
            b => {
                ran      => "",
                constant => [1]
            }
        }
    },
    g1 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [1]
            },
            b => {
                ran      => "",
                constant => [1]
            }
        }
    }
};

&main();
# &read_file;
sub main {
    my $data_example0 = read_file();
    my $result = causalize($data_example0);
    warn "result data_example0:" . Dumper($result);

    my $expected = {
          'topological_sort' => [
                                  {
                                    '1' => [
                                             'a1',
                                             'b1',
                                             'f1',
                                             'g1'
                                           ],
                                    '2' => [
                                             'a2to100',
                                             'b2to100',
                                             'fi',
                                             'gi'
                                           ]
                                  },
                                  {
                                    'order' => [
                                                 1,
                                                 2
                                               ]
                                  }
                                ],
          'ordered_graph' => [
                               'a2to100,b2to100,fi,gi -> a1,b1,f1,g1'
                             ],
          'all_macro_node' => [
                               [
                                             'a1',
                                             'b1',
                                             'f1',
                                             'g1'
                                           ],
                                [
                                             'a2to100',
                                             'b2to100',
                                             'fi',
                                             'gi'
                                           ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'index' => '',
                                               'var_solved_in_other_mn' => {},
                                               'name' => 'a1,b1,f1,g1',
                                               'equations' => [
                                                                'f1',
                                                                'g1'
                                                              ],
                                               'ran' => '',
                                               'var_info' => {
                                                               'b' => [
                                                                        1
                                                                      ],
                                                               'a' => [
                                                                        1
                                                                      ]
                                                             }
                                             },
                                             {
                                               'ran' => {
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'init' => 2,
                                                          'end' => 100,
                                                          'next' => 1
                                                        },
                                               'name' => 'a2to100,b2to100,fi,gi',
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'b' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '-1' => {
                                                                                                                     'init' => 1,
                                                                                                                     'end' => 99
                                                                                                                   }
                                                                                                         }
                                                                                              }
                                                                                     }
                                                                           },
                                               'index' => {
                                                            'b' => 0,
                                                            'a' => 0
                                                          }
                                             }
                                           ]
        };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub read_file {

    my $example;

    my $filename = '/Users/emanuel/Documents/personal/facultad/causalize/5/t/DataExample/example0.txt';

    if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
        
      while (my $row = <$fh>) {
        chomp $row;
        if($example) {
            $example .= $row;
        }
        if($row =~ /\;/ ) {
            $example .= $row;
            last;
        }
        if($row =~ /my/ ) {
            $example .= $row;
        }
        print "$row\n";
      }
    } else {
      warn "Could not open file '$filename' $!";
    }

    return $example;
}

sub compare_internal_macro_node_ordered {
    my ( $first_mn, $second_mn ) = @_;

    foreach my $f_mn (@${first_mn}) {
        my $f_mn_name = $f_mn->{name};
        my $f_mn_eq = $f_mn->{equations};
        my $f_mn_var_info = $f_mn->{var_info};
        my $f_mn_ran = $f_mn->{ran};
        my $f_mn_index = $f_mn->{index};
        my $f_mn_var_solved_in_other_mn = $f_mn->{var_solved_in_other_mn};

        my $match_mn = 0;
        foreach my $s_mn (@${second_mn}) {
            my $s_mn_name = $s_mn->{name};
            if ($f_mn_name eq $s_mn_name ) {
                $match_mn = 1;

                my $s_mn_eq = $s_mn->{equations};
                my $s_mn_var_info = $s_mn->{var_info};
                my $s_mn_ran = $s_mn->{ran};
                my $s_mn_index = $s_mn->{index};
                my $s_mn_var_solved_in_other_mn = $s_mn->{var_solved_in_other_mn};

                # check equations
                if(compare_arrays($f_mn_eq,$s_mn_eq,1) == 0) {
                    warn "$s_mn_name compare_arrays return 0";
                    return 0;
                }

                # check var_info
                if(compare_hash($f_mn_var_info,$s_mn_var_info) == 0) {
                    warn "$s_mn_name compare_hash var_info return 0";
                    return 0;
                }

                # check ran
                if(compare_hash($f_mn_ran,$s_mn_ran) == 0) {
                    warn "$s_mn_name compare_hash ran return 0";
                    return 0;
                }

                # check index
                if(compare_hash($f_mn_index,$s_mn_index) == 0) {
                    warn "$s_mn_name compare_hash index return 0";
                    return 0;
                }

                # var solved in other mn
                if(compare_hash($f_mn_var_solved_in_other_mn,$s_mn_var_solved_in_other_mn) == 0) {
                    warn "$s_mn_name compare_hash var_solved_in_other_mn return 0";
                    return 0;
                }       
            }
        }
        if($match_mn == 0) {
            warn "Macro node: ".Dumper($f_mn)."no match\n";
            return 0;
        }
    }
    return 1;
}

sub compare_all_macro_node {
    my ( $array1, $array2 ) = @_;

    my @array1_expanded;
    my @array2_expanded;

    foreach my $arr (@$array1) {
        foreach my $a (@$arr) {
            push @array1_expanded, $a;
        }
    }

    @array1_expanded = sort(@array1_expanded);

    foreach my $arr (@$array2) {
        foreach my $a (@$arr) {
            push @array2_expanded, $a;
        }
    }

    @array2_expanded = sort(@array2_expanded);

    my $ar1 = join('-',@array1_expanded);
    my $ar2 = join('-',@array2_expanded);

    if ($ar1 eq $ar2) {
        return 1;
    }
    else {
        print "\nFail:";
        print "\nar1: " .Dumper($ar1);
        print "\nar2: " .Dumper($ar2);
        return 0;
    }
}

sub compare_ordered_graph {
    my ( $array1, $array2, $warn ) = @_; 

    foreach my $arr1 (@$array1){
        my $is_included = 0;

        foreach my $arr2 (@$array2) {
            if($arr1 eq $arr2) {
                $is_included = 1;
            }
        }

        if (!$is_included) {
            print $arr1 . " is not included in array2\n";
            return 0;
        }
    }

    foreach my $arr2 (@$array2){
        my $is_included = 0;

        foreach my $arr1 (@$array1) {
            if($arr2 eq $arr1) {
                $is_included = 1;
            }
        }

        if (!$is_included) {
            print $arr2 . " is not included in array1\n";
            return 0;
        }
    }

    # ok $array1 is igual to $array2
    return 1;
}

sub compare_arrays {
    my ( $first, $second, $warn ) = @_;

    return 0 unless @$first == @$second;

    for ( my $i = 0; $i < @$first; $i++ ) {
        if ($first->[$i] ne $second->[$i]) {
            warn "Error: first: " .Dumper($first->[$i]) . " second: " . Dumper($second->[$i]) . "\n" if($warn);
            return 0;
        }
    }

    # ok $first is igual to $second
    return 1;
}

sub compare_hash {
    my ( $hash1, $hash2 ) = @_;

    return 1 if(!$hash1 && !$hash2);

    if($hash1) {
        unless ($hash2) {
            warn "hash1: " . Dumper($hash1) . " and hash2 not defined\n";
            return 0;
        }
    }
    if($hash2) {
        unless ($hash1) {
            warn "hash2: " . Dumper($hash2) . " and hash1 not defined\n";
            return 0;
        }
    }

    for my $clave1 (keys %{$hash1}) {
        if (exists $hash2->{$clave1}) {
            if (ref($hash1->{$clave1}) eq 'ARRAY') {
                if(compare_arrays($hash1->{$clave1},$hash2->{$clave1})){
                    next;
                }
                else {
                    warn Dumper($hash1->{$clave1}) . " ne " . Dumper($hash2->{$clave1}) . "\n";
                    return 0;
                }
            }
            elsif (ref($hash1->{$clave1}) eq 'HASH') {
                if(compare_hash($hash1->{$clave1},$hash2->{$clave1})){
                    next;
                }
                else {
                    warn Dumper($hash1->{$clave1}) . " ne " . Dumper($hash2->{$clave1}) . "\n";
                    return 0;
                }
            }
            elsif($hash1->{$clave1} ne $hash2->{$clave1}) {
                warn Dumper($hash1->{$clave1}) . " ne " . Dumper($hash2->{$clave1}) . "\n";
                return 0;
            }
        }
    }

    # ok $hash1 is igual to $hash2
    return 1;
}

1;