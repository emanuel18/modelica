
use Data::Dumper;
use lib "/Users/emanuel/Documents/personal/facultad/causalize/";

use strict;
use warnings;
use 5.010;
 
use Test::Simple;
use Test::More;
use constant N => 10;

use VarSolvedInOtherMN qw(get_vars_solver_in_other_mn);

# Example 2
# a[N], b[N]
# for i in 1:N-2 loop
#   a[i]-b[i]-a[N]=8;     //fi
#   a[i]+b[i]-a[i+1]=5;   //gi
# end for;
#
# a[N-1]*b[N-1]=8;        //f2
# a[N-1]*3*b[N-1]=5;      //g2
#
# a[N]*b[N]=8;            //f3
# a[N]*3*b[N]=5;          //g3

our $data_example1 = {
    fi => {
        ran => { # rango del for
            0 => {
                init => 1,
                end  => N-2,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran      => "",
                constant => [N]
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
                init => 1,
                end  => N-2,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran   => {
                    0 => {
                        init => 1,
                        end  => N-2,
                    },
                    1 => {
                        init => 2,
                        end  => N-1,
                    }
                },
                constant => ""
            },
            b => {
                ran      => "",
                constant => ""
            }
        }, 
    },
    f2 => {
        ran => "",# si el rango es vacio es que no estas dentro de un for
        var_info => {
            a => {
                ran      => "",
                constant => [N-1]
            },
            b => {
                ran      => "",
                constant => [N-1]
            },
        }
    },
    g2 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [N-1]
            },
            b => {
                ran      => "",
                constant => [N-1]
            },
        }
    },
    f3 => {
        ran => "",# si el rango es vacio es que no estas dentro de un for
        var_info => {
            a => {
                ran      => "",
                constant => [N]
            },
            b => {
                ran      => "",
                constant => [N]
            },
        }
    },
    g3 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [N]
            },
            b => {
                ran      => "",
                constant => [N]
            },
        } 
    },
};

our $internal_macro_node1 = [
     {
       'ran' => '',
       'index' => '',
       'var_info' => {
                       'a' => [
                                9
                              ],
                       'b' => [
                                9
                              ]
                     },
       'name' => 'a9,b9,f2,g2',
       'equations' => [
                        'f2',
                        'g2'
                      ]
     },
     {
       'equations' => [
                        'f3',
                        'g3'
                      ],
       'index' => '',
       'var_info' => {
                       'a' => [
                                10
                              ],
                       'b' => [
                                10
                              ]
                     },
       'ran' => '',
       'name' => 'a10,b10,f3,g3'
     },
     {
       'name' => 'a1to8,b1to8,fi,gi',
       'ran' => {
                  'end' => 1,
                  'init' => 8,
                  'vars' => [
                              'a',
                              'b'
                            ],
                  'next' => -1
                },
       'var_info' => {
                       'b' => '',
                       'a' => ''
                     },
       'index' => {
                    'a' => 0,
                    'b' => 0
                  },
       'equations' => [
                        'fi',
                        'gi'
                      ]
     }
];

# model a
#     Real a[N],b[N];
#     parameter Integer N=5;
# equation
#     for i in 1:N-1 loop
#         a[i]*b[i]*a[i+1]=456;   fi
#         a[i]*b[i]*a[i+1]*345=6; gi
#     end for;
#     //a[N]=234;
#     a[1]=234;                   h1
#     b[N]=234;                   h2
# end a;
our $data_example2 = {
    fi => {
        ran => { # rango del for
            0 => {
                init => 1,
                end  => N-1,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran   => {
                    0 => {
                        init => 1,
                        end  => N-1,
                    },
                    1 => {
                        init => 2,
                        end  => N,
                    }
                },
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
                init => 1,
                end  => N-1,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran   => {
                    0 => {
                        init => 1,
                        end  => N-1,
                    },
                    1 => {
                        init => 2,
                        end  => N,
                    }
                },
                constant => ""
            },
            b => {
                ran      => "",
                constant => ""
            },
        },
    },
    h1 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [1]
            },
        } 
    },
    h2 => {
        ran => "",
        var_info => {
            b => {
                ran      => "",
                constant => [N]
            },
        } 
    },
};

our $internal_macro_node2 = [
        {
       'ran' => {
                  'end' => 9,
                  'init' => 1,
                  'next' => 1,
                  'vars' => [
                              'a',
                              'b'
                            ]
                },
       'name' => 'a2to10,b1to9,fi,gi',
       'var_info' => {
                       'b' => '',
                       'a' => ''
                     },
       'index' => {
                    'a' => 1,
                    'b' => 0
                  },
       'equations' => [
                        'fi',
                        'gi'
                      ]
     },{
       'equations' => [
                        'h2'
                      ],
       'var_info' => {
                       'b' => [
                                10
                              ]
                     },
       'index' => '',
       'name' => 'b10,h2',
       'ran' => ''
     },{
       'name' => 'a1,h1',
       'ran' => '',
       'equations' => [
                        'h1'
                      ],
       'var_info' => {
                       'a' => [
                                1
                              ]
                     },
       'index' => ''
     }
];

# Example 3
# equation
#   for i in 1:9 loop
#       a[i]*b[i]=1;         fi19
#       a[i]+b[i]^2=0;       gi19
#       c[i]=a[i+1]+3*b[i];  hi19
#   end for;
#
#     a[10]*b[10]=1;         f10
#     a[10]+b[10]^2=0;       g10
#     c[10]=3*b[10];         k10
# end Ejemplo;

our $data_example3 = {
    fi19 => {
        ran => { 
            0 => {
                init => 1,
                end  => 9,
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
            }
        }, 
    },
    gi19 => {
        ran => {
            0 => {
                init => 1,
                end  => 9,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran   => "",
                constant => ""
            },
            b => {
                ran      => "",
                constant => ""
            }
        }, 
    },
    hi19 => {
        ran => {
            0 => {
                init => 1,
                end  => 9,
                vars => ['a','b','c']
            }
        },
        var_info => {
            a => {
                ran   => {  
                    1 => {
                        init => 2,
                        end  => 10,
                    }
                },
                constant => ""
            },
            b => {
                ran      => "",
                constant => ""
            },
            c => {
                ran      => "",
                constant => ""
            }
        }, 
    },
    f10 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [10]
            },
            b => {
                ran      => "",
                constant => [10]
            },
        }, 
    },
    g10 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [10]
            },
            b => {
                ran      => "",
                constant => [10]
            },
        }, 
    },
    k10 => {
        ran => "",
        var_info => {
            b => {
                ran      => "",
                constant => [10]
            },
            c => {
                ran      => "",
                constant => [10]
            }
        }
    },
};

my $internal_macro_node3 = [
          {
            'ran' => {
                       'next' => 1,
                       'vars' => [
                                   'a',
                                   'b'
                                 ],
                       'init' => 1,
                       'end' => 9
                     },
            'name' => 'a1to9,b1to9,fi19,gi19',
            'equations' => [
                             'fi19',
                             'gi19'
                           ],
            'index' => {
                         'a' => 0,
                         'b' => 0
                       },
            'var_info' => {
                            'b' => '',
                            'a' => ''
                          }
          },
          {
            'equations' => [
                             'k10'
                           ],
            'index' => '',
            'var_info' => {
                            'c' => [
                                     10
                                   ]
                          },
            'ran' => '',
            'name' => 'c10,k10'
          },
          {
            'ran' => {
                       'vars' => [
                                   'c'
                                 ],
                       'init' => 1,
                       'end' => 9,
                       'next' => 1
                     },
            'name' => 'c1to9,hi19',
            'equations' => [
                             'hi19'
                           ],
            'index' => {
                         'c' => 0
                       },
            'var_info' => {
                            'c' => ''
                          }
          },
          {
            'name' => 'a10,b10,fi10,gi10',
            'ran' => '',
            'var_info' => {
                            'a' => [
                                     10
                                   ],
                            'b' => [
                                     10
                                   ]
                          },
            'index' => '',
            'equations' => [
                             'fi10',
                             'gi10'
                           ]
          }
        ];

&main();

sub main {

    # test_example_1();

    # test_example_2();

    test_example_3();

    


    # test();

}

sub test {
    my $result1 = get_vars_solved_in_other_mn(
        init_data           => $data_example1,
        internal_macro_node => $internal_macro_node1
    );

    my $expected1 = {
          'gi' => {
                    'a' => {
                             'end' => {
                                        'min' => 9,
                                        'max' => 9
                                      }
                           }
                  },
          'fi' => {
                    'a' => {
                             'constant' => [
                                             10
                                           ]
                           }
                  }
        };

    my $result2 = get_vars_solved_in_other_mn(
        init_data           => $data_example2,
        internal_macro_node => $internal_macro_node2
    );

    my $expected2 = {
          'gi' => {
                    'a' => {
                             'init' => {
                                         'max' => 1,
                                         'min' => 1
                                       }
                           }
                  },
          'fi' => {
                    'a' => {
                             'init' => {
                                         'min' => 1,
                                         'max' => 1
                                       }
                           }
                  }
    };

    is_deeply($expected1, $result1, "Ok Test 2");
    is_deeply($expected2, $result2, "Ok Test 2");

}
sub test_example_1 {
    my $result = get_vars_solved_in_other_mn(
        init_data           => $data_example1,
        internal_macro_node => $internal_macro_node1
    );
    warn Dumper($internal_macro_node1);

    # my $expected = {
    #       'gi' => {
    #                 'a' => {
    #                          'end' => {
    #                                     'min' => 9,
    #                                     'max' => 9
    #                                   }
    #                        }
    #               },
    #       'fi' => {
    #                 'a' => {
    #                          'constant' => [
    #                                          10
    #                                        ]
    #                        }
    #               }
    #     };
    # is_deeply($expected, $result, "Ok Test 2");
}

sub test_example_2 {
    my $result = get_vars_solved_in_other_mn(
        init_data           => $data_example2,
        internal_macro_node => $internal_macro_node2
    );

    my $expected = {
          'gi' => {
                    'a' => {
                             'init' => {
                                         'max' => 1,
                                         'min' => 1
                                       }
                           }
                  },
          'fi' => {
                    'a' => {
                             'init' => {
                                         'min' => 1,
                                         'max' => 1
                                       }
                           }
                  }
    };
    is_deeply($expected, $result, "Ok Test 2");
}


sub test_example_3 {
    get_vars_solved_in_other_mn(
        init_data           => $data_example3,
        internal_macro_node => $internal_macro_node3
    );
    warn Dumper($internal_macro_node3);
    my $expected = [
          {
            'ran' => {
                       'next' => 1,
                       'vars' => [
                                   'a',
                                   'b'
                                 ],
                       'init' => 1,
                       'end' => 9
                     },
            'name' => 'a1to9,b1to9,fi19,gi19',
            'equations' => [
                             'fi19',
                             'gi19'
                           ],
            'index' => {
                         'a' => 0,
                         'b' => 0
                       },
            'var_info' => {
                            'b' => '',
                            'a' => ''
                          },
          },
          {
            'equations' => [
                             'k10'
                           ],
            'index' => '',
            'var_info' => {
                            'c' => [
                                     10
                                   ]
                          },
            'ran' => '',
            'name' => 'c10,k10',
            'var_solved_in_other_mn' => {
                'k10' => {
                    'b' => {
                        'constant' => [10],
                        'ran' => ""
                    }
                }
            } 
          },
          {
            'ran' => {
                       'vars' => [
                                   'c'
                                 ],
                       'init' => 1,
                       'end' => 9,
                       'next' => 1
                     },
            'name' => 'c1to9,hi19',
            'equations' => [
                             'hi19'
                           ],
            'index' => {
                         'c' => 0
                       },
            'var_info' => {
                            'c' => ''
                          },
            'var_solved_in_other_mn' => {
                'hi19' => {
                    'b' => {
                        'ran' => {
                            '0' => {
                                'vars' => [
                                     'a',
                                     'b',
                                     'c'
                                ],
                              'init' => 1,
                              'end' => 9
                            }
                        },
                        'constant' => ""
                   },
                    'a' => {
                        'ran' => {
                              1 => {
                                  'init' => 2,
                                  'end' => 10,
                              },
                        },
                        'constant' => ""
                    }
                }
            } 
          },
          {
            'name' => 'a10,b10,fi10,gi10',
            'ran' => '',
            'var_info' => {
                            'a' => [
                                     10
                                   ],
                            'b' => [
                                     10
                                   ]
                          },
            'index' => '',
            'equations' => [
                             'fi10',
                             'gi10'
                           ]
          }
        ];
    is_deeply($expected, $internal_macro_node3, "Ok Test 3");
}

sub compare_internal_macro_node_ordered {
    my ( $first_mn, $second_mn ) = @_;

    foreach my $f_mn (@${first_mn}) {
        my $f_mn_name = $f_mn->{name};
        my $f_mn_eq = $f_mn->{equations};
        my $f_mn_var_info = $f_mn->{var_info};
        my $f_mn_ran = $f_mn->{ran};
        my $f_mn_index = $f_mn->{index};

        my $match_mn = 0;
        foreach my $s_mn (@${second_mn}) {
            my $s_mn_name = $s_mn->{name};#warn "f_mn_name:$f_mn_name s_mn_name:$s_mn_name\n";
            if ($f_mn_name eq $s_mn_name ) {
                $match_mn = 1;

                my $s_mn_eq = $s_mn->{equations};
                my $s_mn_var_info = $s_mn->{var_info};
                my $s_mn_ran = $s_mn->{ran};
                my $s_mn_index = $s_mn->{index};

                # check equations
                if(compare_arrays($f_mn_eq,$s_mn_eq,1) == 0) {
                    warn "compare_arrays return 0";
                    return 0;
                }

                # check var_info
                if(compare_hash($f_mn_var_info,$s_mn_var_info) == 0) {
                    warn "compare_hash var_info return 0";
                    return 0;
                }

                # check ran
                if(compare_hash($f_mn_ran,$s_mn_ran) == 0) {
                    warn "compare_hash ran return 0";
                    return 0;
                }

                # check index
                if(compare_hash($f_mn_index,$s_mn_index) == 0) {
                    warn "compare_hash index return 0";
                    return 0;
                }           
            }
        }
        if($match_mn == 0) {
            warn "Macro node: no match\n";
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