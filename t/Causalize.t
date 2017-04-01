
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

# Example 1
# a[N], b[N], c
# for i in 1:N-2 loop
#   a[i]-b[i]=8;         //fi
#   a[i]+b[i]-a[i+1]=5;  //gi
# end for;
#
# a[N-1]-b[N-1]=8;      //f2
# a[N-1]+b[N-1]=5;      //g2
#
# a[N] = 22             //h1
# a[N] + b[N] + c = 22  //h2
# c = 10                //h3
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
            }
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
            }
        }
    },
    h1 => {
        ran => "",# si el rango es vacio es que no estas dentro de un for
        var_info => {
            a => {
                ran      => "",
                constant => [N]
            }
        }
    },
    h2 => {
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
            c => {
                ran      => "",
                constant => ""
            },
        }
    },
    h3 => {
        ran => "",
        var_info => {
            c => {
                ran      => "",
                constant => ""
            },
        } 
    },
};

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

our $data_example2 = {
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

# Example 3
# model a
#     Real a[N],b[N];
#     parameter Integer N=5;
# equation
#     for i in 1:N-1 loop
#         a[i]*b[i]*a[i+1]=456;   fi
#         a[i]*b[i]*a[i+1]*345=6; gi
#     end for;
#     a[1]=234;                   h1
#     b[N]=234;                   h2
# end a;
our $data_example3a = {
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

# Example 3
# model a
#     Real a[N],b[N];
#     parameter Integer N=5;
# equation
#     for i in 1:N-1 loop
#         a[i]*b[i]*a[i+1]=456;   fi
#         a[i]*b[i]*a[i+1]*345=6; gi
#     end for;
#     a[N]=234;                   h1
#     b[N]=234;                   h2
# end a;
our $data_example3b = {
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
                constant => [N]
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

# Example 4
# model a
#     Real a[N],b[N];
#     parameter Integer N=5;
# equation
#     for i in 2:N loop
#         a[i]*b[i]=456;          fi
#         a[i]*b[i]*b[i-1]*345=6; gi
#     end for;
#     a[1]=234;                   h1
#     b[1]=234;                   h2
# end a;
our $data_example4= {
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
            },
            a => {
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
                constant => [1]
            },
        } 
    },
};

# Example 4a
# model a
#     Real a[100],b[100];
#     parameter Integer N=5;
# equation
#     for i in 3:100 loop 
#         a[i]*b[i]=456;           fi     
#     end for;
#     for i in 2:100 loop
#         a[i]*b[i]*b[i-1]*345=6;  gi
#     end for;
#     a[1]=234;                    h1
#     b[1]=23;                     h2
#     b[2]=2;                      h3
# end a;
our $data_example4a = {
    fi => {
        ran => { # rango del for
            0 => {
                init => 3,
                end  => 100,
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
                end  => 100,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran      => "",
                constant => ""
            },,
            b => {
                ran   => {
                    0 => {
                        init => 2,
                        end  => 100,
                    },
                    -1 => {
                        init => 1,
                        end  => 99,
                    }
                },
                constant => ""
            }
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
                constant => [1]
            },
        } 
    },
    h3 => {
        ran => "",
        var_info => {
            b => {
                ran      => "",
                constant => [2]
            },
        } 
    },
};

# Example 4a
# model a
#     Real a[100],b[100];
#     parameter Integer N=5;
# equation
#     for i in 3:100 loop 
#         a[i]*b[i]=456;           fi3100
#         a[i]*b[i]*b[i-1]*345=6;  gi3100   
#     end for;

#     a[2]*b[2]*b[1]*345=6;        gi2

#     a[1]=234;                    h1
#     b[1]=23;                     h2
#     b[2]=2;                      h3
# end a;
our $data_example4b = {
    fi3100 => {
        ran => { # rango del for
            0 => {
                init => 3,
                end  => 99,
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
    gi3100 => {
        ran => {
            0 => {
                init => 3,
                end  => 100,
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
                        init => 3,
                        end  => 100,
                    },
                    -1 => {
                        init => 2,
                        end  => 99,
                    }
                },
                constant => ""
            }
        },
    },
    gi2 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [2]
            },
            b => {
                ran      => "",
                constant =>[1,2]
            }
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
                constant => [1]
            },
        } 
    },
    h3 => {
        ran => "",
        var_info => {
            b => {
                ran      => "",
                constant => [2]
            },
        } 
    },
};


# model a
#     Real a[N],b[N];
#     parameter Integer N=5;
# equation
#     for i in 1:N-1 loop
#         a[i+1]*b[i]=456;   fi
#         a[i+1]*b[i]*345=6; gi
#     end for;
#     a[1]=23;                   h1
#     b[N]=8;                    h2
# end a;
our $data_example5 = {
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


# Example 6a
# equation
#   for i in 1:N loop
#       a[i]*b[i]=1;         fi
#       a[i]+b[i]^2=0;       gi
#   end for;
#     for i in 1:N-1 loop
#       c[i]=a[i+1]+3*b[i];  hi
#     end for;
#     c[N]=3*b[N];           k10
# end Ejemplo;

our $data_example6a = {
    fi => {
        ran => { 
            0 => {
                init => 1,
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
            }
        }, 
    },
    gi => {
        ran => {
            0 => {
                init => 1,
                end  => N,
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
    hi => {
        ran => {
            0 => {
                init => 1,
                end  => N-1,
                vars => ['a','b','c'] # aca no va a xq el indice de a es i+1 solamente, entonces no esta dentro del for
            }
        },
        var_info => {
            a => {
                ran   => {  
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
            c => {
                ran      => "",
                constant => ""
            }
        }, 
    },
    k10 => {
        ran => "",
        var_info => {
            b => {
                ran      => "",
                constant => [N]
            },
            c => {
                ran      => "",
                constant => [N]
            }
        }
    },
};

# Example 6b
# equation
#   for i in 1:N-1 loop
#       a[i]*b[i]=1;         fi19
#       a[i]+b[i]^2=0;       gi19
#       c[i]=a[i+1]+3*b[i];  hi19
#   end for;
#
#     a[N]*b[N]=1;         f10
#     a[N]+b[N]^2=0;       g10
#     c[N]=3*b[N];         k10
# end Ejemplo;

our $data_example6b = {
    fi19 => {
        ran => { 
            0 => {
                init => 1,
                end  => N-1,
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
                end  => N-1,
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
                end  => N-1,
                vars => ['a','b','c']
            }
        },
        var_info => {
            a => {
                ran   => {  
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
            c => {
                ran      => "",
                constant => ""
            }
        }, 
    },
    fi10 => {
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
        }, 
    },
    gi10 => {
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
        }, 
    },
    k10 => {
        ran => "",
        var_info => {
            b => {
                ran      => "",
                constant => [N]
            },
            c => {
                ran      => "",
                constant => [N]
            }
        }
    },
};

# Example 7
# model a
#     Real a[N],b[N],c,d;
# equation
#     for i in 1:N-1 loop
#         a[i]*b[i]+c=0;        fi
#         a[i]*b[i]*b[i+1]=6;   gi
#     end for;
#     a[N]+d=2;               h1
#     b[N]=4;                 h2
#     c=10;                   h3
#     d=20;                   h4
# end a;
our $data_example7 = {
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
                ran      => "",
                constant => ""
            },
            b => {
                ran      => "",
                constant => ""
            },
            c => {
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
                ran      => "",
                constant => ""
            },
            b => {
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
            }
        },
    },
    h1 => {
        ran => "",
        var_info => {
            a => {
                ran      => "",
                constant => [N]
            },
            d => {
                ran      => "",
                constant => ""
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
    h3 => {
        ran => "",
        var_info => {
            c => {
                ran      => "",
                constant => ""
            },
        } 
    },
    h4 => {
        ran => "",
        var_info => {
            d => {
                ran      => "",
                constant => ""
            },
        } 
    },
};

&main();

sub main {

    # my $result = causalize($data_example6a);
    # warn Dumper($result);
    # test_example_0();
    # test_example_1();

    # test_example_2();

    # test_example_3a();
    # test_example_3b();
    
    # test_example_4();
    # test_example_4_ab();
    # test_example_5();
    # test_example_6a();
    # test_example_6b();
    # test_example_7();
    


    test_1_2_3_4_5_6_7();

}

sub test_1_2_3_4_5_6_7 {

    my $result1 = causalize($data_example1);

    my $expected1 = {
          'internal_macro_node_ordered' => [
                                             {
                                                'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'end' => 99,
                                                                                                                    'init' => 2
                                                                                                                  }
                                                                                                         },
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'name' => 'a1to'.N_2.',b1to'.N_2.',fi,gi',
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'ran' => {
                                                          'next' => -1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'end' => 1,
                                                          'init' => N_2
                                                        },
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                                'index' => {
                                                    'a' => 0,
                                                    'b' => 0,
                                                }
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'f2',
                                                                'g2'
                                                              ],
                                               'ran' => '',
                                               'var_info' => {
                                                               'a' => [
                                                                        N_1
                                                                      ],
                                                               'b' => [
                                                                        N_1
                                                                      ]
                                                             },
                                               'name' => 'a'.N_1.',b'.N_1.',f2,g2',
                                               'index' => ''
                                             },
                                             {
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {
                                                                             'h2' => {
                                                                                       'a' => {
                                                                                                'ran' => '',
                                                                                                'constant' => [
                                                                                                                100
                                                                                                              ]
                                                                                              },
                                                                                       'c' => {
                                                                                                'ran' => '',
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'name' => 'b'.N.',h2',
                                               'index' => ''
                                             },
                                             {
                                               'name' => 'a'.N.',h1',
                                               'var_solved_in_other_mn' => {},
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ]
                                                             },
                                               'ran' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                                'index' => ''
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'h3'
                                                              ],
                                               'var_info' => {
                                                               'c' => []
                                                             },
                                               'ran' => '',
                                               'name' => 'c,h3',
                                               'index' => ''
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                  'a1to'.N_2,
                                  'b1to'.N_2,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'a'.N_1,
                                  'b'.N_1,
                                  'f2',
                                  'g2'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a'.N,
                                  'h1'
                                ],
                                [
                                  'c',
                                  'h3'
                                ]
                              ],
          'ordered_graph' => [
                               'a1to'.N_2.',b1to'.N_2.',fi,gi -> a'.N_1.',b'.N_1.',f2,g2',
                               'b'.N.',h2 -> a'.N.',h1',
                               'b'.N.',h2 -> c,h3'
                             ]
    };

    my $result2 = causalize($data_example2);

    my $expected2 = {
          'all_macro_node' => [
                                [
                                  'a'.N_1,
                                  'b'.N_1,
                                  'f2',
                                  'g2'
                                ],
                                [
                                  'a'.N,
                                  'b'.N,
                                  'f3',
                                  'g3'
                                ],
                                [
                                  'a1to'.N_2,
                                  'b1to'.N_2,
                                  'fi',
                                  'gi'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'ran' => '',
                                               'index' => '',
                                               'var_info' => {
                                                               'a' => [
                                                                        N_1
                                                                      ],
                                                               'b' => [
                                                                        N_1
                                                                      ]
                                                             },
                                               'name' => 'a'.N_1.',b'.N_1.',f2,g2',
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
                                                                        N
                                                                      ],
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'ran' => '',
                                               'name' => 'a'.N.',b'.N.',f3,g3',
                                               'var_solved_in_other_mn' => {}
                                             },
                                             {
                                               'name' => 'a1to'.N_2.',b1to'.N_2.',fi,gi',
                                               'ran' => {
                                                          'end' => 1,
                                                          'init' => N_2,
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
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'fi' => {
                                                                                       'a' => {
                                                                                                'constant' => [
                                                                                                                100
                                                                                                              ],
                                                                                                'ran' => ''
                                                                                              }
                                                                                     },
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'init' => 2,
                                                                                                                    'end' => 99
                                                                                                                  }
                                                                                                         },
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                             }
                                           ],
          'ordered_graph' => [
                               'a1to'.N_2.',b1to'.N_2.',fi,gi -> a'.N.',b'.N.',f3,g3',
                               'a1to'.N_2.',b1to'.N_2.',fi,gi -> a'.N_1.',b'.N_1.',f2,g2'
                             ]
    };
    my $result3a = causalize($data_example3a);

    my $expected3a = {
        'internal_macro_node_ordered' => [
                                             {
                                               'ran' => {
                                                          'end' => N_1,
                                                          'init' => 1,
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ]
                                                        },
                                               'name' => 'a2to'.N.',b1to'.N_1.',fi,gi',
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
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '0' => {
                                                                                                                    'init' => 1,
                                                                                                                    'end' => 99,
                                                                                                                    'vars' => [
                                                                                                                                'a',
                                                                                                                                'b'
                                                                                                                              ]
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     },
                                                                             'fi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '0' => {
                                                                                                                    'init' => 1,
                                                                                                                    'vars' => [
                                                                                                                                'a',
                                                                                                                                'b'
                                                                                                                              ],
                                                                                                                    'end' => 99
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     }
                                                                           },
                                             },
                                             {
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'b'.N.',h2',
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {},
                                             },
                                             {
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
                                               'index' => '',
                                               'var_solved_in_other_mn' => {},
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                  'a2to'.N,
                                  'b1to'.N_1,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a1',
                                  'h1'
                                ]
                              ],
          'ordered_graph' => [
                               'a2to'.N.',b1to'.N_1.',fi,gi -> a1,h1',
                             ]
        };

    my $result3b = causalize($data_example3b);

    my $expected3b = {
        'internal_macro_node_ordered' => [
                                             {
                                               'ran' => {
                                                          'end' => 1,
                                                          'init' => N_1,
                                                          'next' => -1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ]
                                                        },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi,gi',
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
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'end' => 100,
                                                                                                                    'init' => 2
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     },
                                                                             'fi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'end' => 100,
                                                                                                                    'init' => 2
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     }
                                                                           },
                                             },
                                             {
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'b'.N.',h2',
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {}
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'name' => 'a'.N.',h1',
                                               'ran' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => ''
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                  'a1to'.N_1,
                                  'b1to'.N_1,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a'.N,
                                  'h1'
                                ]
                              ],
          'ordered_graph' => [
                               'a1to'.N_1.',b1to'.N_1.',fi,gi -> a'.N.',h1',
                             ]
        };

    my $result4 = causalize($data_example4);

    #warn Dumper($result);
    my $expected4 = {
          'ordered_graph' => [
                               'a2to'.N.',b2to'.N.',fi,gi -> b1,h2'
                             ],
          'all_macro_node' => [
                                [
                                  'a2to'.N,
                                  'b2to'.N,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'a1',
                                  'h1'
                                ],
                                [
                                  'b1',
                                  'h2'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                               'name' => 'a2to'.N.',b2to'.N.',fi,gi',
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'init' => 2,
                                                          'end' => N
                                                        },
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                                'var_solved_in_other_mn' => {
                                                             'gi' => {
                                                                       'b' => {
                                                                                'ran' => {
                                                                                           '-1' => {
                                                                                                     'end' => 99,
                                                                                                     'init' => 1
                                                                                                   }
                                                                                         },
                                                                                'constant' => ''
                                                                              }
                                                                     }
                                                           },

                                             },
                                             {
                                               'var_info' => {
                                                               'a' => [
                                                                        1
                                                                      ]
                                                             },
                                               'index' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                               'ran' => '',
                                               'name' => 'a1,h1',
                                               'var_solved_in_other_mn' => {},
                                             },
                                             {
                                               'index' => '',
                                               'ran' => '',
                                               'name' => 'b1,h2',
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'var_info' => {
                                                               'b' => [
                                                                        1
                                                                      ]
                                                             },
                                                'var_solved_in_other_mn' => {},
                                             }
                                           ],
    };

    my $result5 = causalize($data_example5);

    my $expected5 = {
          'all_macro_node' => [
                                [
                                  'a2to'.N,
                                  'b1to'.N_1,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a1',
                                  'h1'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                               'ran' => {
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'next' => 1,
                                                          'end' => N_1,
                                                          'init' => 1
                                                        },
                                               'name' => 'a2to'.N.',b1to'.N_1.',fi,gi',
                                               'index' => {
                                                            'b' => 0,
                                                            'a' => 1
                                                          },
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                                'var_solved_in_other_mn' => {},
                                             },
                                             {
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'ran' => '',
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'name' => 'b'.N.',h2',
                                               'index' => '',
                                                'var_solved_in_other_mn' => {},
                                             },
                                             {
                                               'ran' => '',
                                               'name' => 'a1,h1',
                                               'index' => '',
                                               'var_info' => {
                                                               'a' => [
                                                                        1
                                                                      ]
                                                             },
                                               'equations' => [
                                                                'h1'
                                                              ],
                                             'var_solved_in_other_mn' => {},
                                             },
                                           ],
          'ordered_graph' => []
    };

    my $result6a = causalize($data_example6a);
    my $result6b = causalize($data_example6b);

    my $expected6a =  {
          'all_macro_node' => [
                                [
                                  'a1to'.N_1,
                                  'b1to'.N_1,
                                  'fi1'.N_1,
                                  'gi1'.N_1
                                ],
                                [
                                  'c1to'.N_1,
                                  'hi1'.N_1
                                ],
                                [
                                  'a'.N,
                                  'b'.N,
                                  'fi'.N,
                                  'gi'.N
                                ],
                                [
                                  'c'.N,
                                  'k10'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi1'.N_1.',gi1'.N_1,
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                               'ran' => {
                                                          'end' => N_1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'next' => 1,
                                                          'init' => 1
                                                        },
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi1'.N_1,
                                                                'gi1'.N_1
                                                              ]
                                             },
                                             {
                                               'index' => {
                                                            'c' => 0
                                                          },
                                               'name' => 'c1to'.N_1.',hi1'.N_1,
                                               'var_info' => {
                                                               'c' => ''
                                                             },
                                               'equations' => [
                                                                'hi1'.N_1
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'hi1'.N_1 => {
                                                                                         'a' => {
                                                                                                  'ran' => {
                                                                                                             '1' => {
                                                                                                                      'end' => N,
                                                                                                                      'init' => 2
                                                                                                                    }
                                                                                                           },
                                                                                                  'constant' => ''
                                                                                                },
                                                                                         'b' => {
                                                                                                  'constant' => '',
                                                                                                  'ran' => {
                                                                                                             '0' => {
                                                                                                                      'end' => N_1,
                                                                                                                      'vars' => [
                                                                                                                                  'a',
                                                                                                                                  'b',
                                                                                                                                  'c'
                                                                                                                                ],
                                                                                                                      'init' => 1
                                                                                                                    }
                                                                                                           }
                                                                                                }
                                                                                       }
                                                                           },
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'c'
                                                                    ],
                                                          'end' => N_1,
                                                          'init' => 1
                                                        }
                                             },
                                             {
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi'.N,
                                                                'gi'.N
                                                              ],
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ],
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'a'.N.',b'.N.',fi'.N.',gi'.N
                                             },
                                             {
                                               'var_info' => {
                                                               'c' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'c'.N.',k10',
                                               'ran' => '',
                                               'equations' => [
                                                                'k10'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'k10' => {
                                                                                        'b' => {
                                                                                                 'ran' => '',
                                                                                                 'constant' => [
                                                                                                                 N
                                                                                                               ]
                                                                                               }
                                                                                      }
                                                                           }
                                             }
                                           ],
          'ordered_graph' => [
                               'c1to'.N_1.',hi1'.N_1.' -> a1to'.N_1.',b1to'.N_1.',fi1'.N_1.',gi1'.N_1,
                               'c1to'.N_1.',hi1'.N_1.' -> a'.N.',b'.N.',fi'.N.',gi'.N,
                               'c'.N.',k10 -> a'.N.',b'.N.',fi'.N.',gi'.N
                             ],
    };
    my $expected6b =  {
          'all_macro_node' => [
                                [
                                  'a1to'.N_1,
                                  'b1to'.N_1,
                                  'fi19',
                                  'gi19'
                                ],
                                [
                                  'c1to'.N_1,
                                  'hi19'
                                ],
                                [
                                  'a'.N,
                                  'b'.N,
                                  'fi10',
                                  'gi10'
                                ],
                                [
                                  'c'.N,
                                  'k10'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi19,gi19',
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                               'ran' => {
                                                          'end' => N_1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'next' => 1,
                                                          'init' => 1
                                                        },
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi19',
                                                                'gi19'
                                                              ]
                                             },
                                             {
                                               'index' => {
                                                            'c' => 0
                                                          },
                                               'name' => 'c1to'.N_1.',hi19',
                                               'var_info' => {
                                                               'c' => ''
                                                             },
                                               'equations' => [
                                                                'hi19'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'hi19' => {
                                                                                         'a' => {
                                                                                                  'ran' => {
                                                                                                             '1' => {
                                                                                                                      'end' => N,
                                                                                                                      'init' => 2
                                                                                                                    }
                                                                                                           },
                                                                                                  'constant' => ''
                                                                                                },
                                                                                         'b' => {
                                                                                                  'constant' => '',
                                                                                                  'ran' => {
                                                                                                             '0' => {
                                                                                                                      'end' => N_1,
                                                                                                                      'vars' => [
                                                                                                                                  'a',
                                                                                                                                  'b',
                                                                                                                                  'c'
                                                                                                                                ],
                                                                                                                      'init' => 1
                                                                                                                    }
                                                                                                           }
                                                                                                }
                                                                                       }
                                                                           },
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'c'
                                                                    ],
                                                          'end' => N_1,
                                                          'init' => 1
                                                        }
                                             },
                                             {
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi10',
                                                                'gi10'
                                                              ],
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ],
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'a'.N.',b'.N.',fi10,gi10'
                                             },
                                             {
                                               'var_info' => {
                                                               'c' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'c'.N.',k10',
                                               'ran' => '',
                                               'equations' => [
                                                                'k10'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'k10' => {
                                                                                        'b' => {
                                                                                                 'ran' => '',
                                                                                                 'constant' => [
                                                                                                                 N
                                                                                                               ]
                                                                                               }
                                                                                      }
                                                                           }
                                             }
                                           ],
          'ordered_graph' => [
                               'c1to'.N_1.',hi19 -> a1to'.N_1.',b1to'.N_1.',fi19,gi19',
                               'c1to'.N_1.',hi19 -> a'.N.',b'.N.',fi10,gi10',
                               'c'.N.',k10 -> a'.N.',b'.N.',fi10,gi10'
                             ],
    };

    my $result7 = causalize($data_example7);

    my $expected7 = {
          'ordered_graph' => [
                               'a1to'.N_1.',b1to'.N_1.',fi,gi -> b'.N.',h2',
                               'a1to'.N_1.',b1to'.N_1.',fi,gi -> c,h3',
                               'a'.N.',h1 -> d,h4'
                             ],
          'topological_sort' => [
                                  {
                                    '5' => [
                                             'c',
                                             'h3'
                                           ],
                                    '2' => [
                                             'd',
                                             'h4'
                                           ],
                                    '3' => [
                                             'a'.N,
                                             'h1'
                                           ],
                                    '4' => [
                                             'b'.N,
                                             'h2'
                                           ],
                                    '1' => [
                                             'a1to'.N_1,
                                             'b1to'.N_1,
                                             'fi',
                                             'gi'
                                           ]
                                  },
                                  {
                                    'order' => [
                                                 2,
                                                 3,
                                                 4,
                                                 5,
                                                 1
                                               ]
                                  }
                                ],
          'internal_macro_node_ordered' => [
                                             {
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'b' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'init' => 2,
                                                                                                                    'end' => N
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     },
                                                                             'fi' => {
                                                                                       'c' => {
                                                                                                'ran' => '',
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi,gi',
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                               'ran' => {
                                                          'end' => 1,
                                                          'next' => -1,
                                                          'init' => N_1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ]
                                                        }
                                             },
                                             {
                                               'equations' => [
                                                                'h4'
                                                              ],
                                               'ran' => '',
                                               'index' => '',
                                               'name' => 'd,h4',
                                               'var_solved_in_other_mn' => {},
                                               'var_info' => {
                                                               'd' => []
                                                             }
                                             },
                                             {
                                               'ran' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                               'name' => 'a'.N.',h1',
                                               'var_solved_in_other_mn' => {
                                                                             'h1' => {
                                                                                       'd' => {
                                                                                                'constant' => '',
                                                                                                'ran' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => ''
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'name' => 'b'.N.',h2',
                                               'index' => '',
                                               'ran' => '',
                                               'equations' => [
                                                                'h2'
                                                              ]
                                             },
                                             {
                                               'ran' => '',
                                               'equations' => [
                                                                'h3'
                                                              ],
                                               'name' => 'c,h3',
                                               'var_info' => {
                                                               'c' => []
                                                             },
                                               'var_solved_in_other_mn' => {},
                                               'index' => ''
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                 'a1to'.N_1,
                                 'b1to'.N_1,
                                 'fi',
                                 'gi'
                                ],
                                [
                                 'd',
                                 'h4'
                                ],
                                [
                                 'a'.N,
                                 'h1'
                                ],
                                [
                                 'b'.N,
                                 'h2'
                                ],
                                [
                                 'c',
                                 'h3'
                                ]
                              ]
    };

    ok(compare_internal_macro_node_ordered($expected1->{internal_macro_node_ordered},$result1->{internal_macro_node_ordered}),"Example 1: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected1->{all_macro_node},$result1->{all_macro_node}),"Example 1: Ok all_macro_node");
    ok(compare_ordered_graph($expected1->{ordered_graph},$result1->{ordered_graph},1),"Example 1: Ok ordered_graph");

    ok(compare_internal_macro_node_ordered($expected2->{internal_macro_node_ordered},$result2->{internal_macro_node_ordered}),"Example 2: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected2->{all_macro_node},$result2->{all_macro_node}),"Example 2: Ok all_macro_node");
    ok(compare_ordered_graph($expected2->{ordered_graph},$result2->{ordered_graph},1),"Example 2: Ok ordered_graph");

    ok(compare_internal_macro_node_ordered($expected3a->{internal_macro_node_ordered},$result3a->{internal_macro_node_ordered}),"Example 3a: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected3a->{all_macro_node},$result3a->{all_macro_node}),"Example 3a: Ok all_macro_node");
    ok(compare_ordered_graph($expected3a->{ordered_graph},$result3a->{ordered_graph},1),"Example 3a: Ok ordered_graph");

    ok(compare_internal_macro_node_ordered($expected3b->{internal_macro_node_ordered},$result3b->{internal_macro_node_ordered}),"Example 3b: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected3b->{all_macro_node},$result3b->{all_macro_node}),"Example 3b: Ok all_macro_node");
    ok(compare_ordered_graph($expected3b->{ordered_graph},$result3b->{ordered_graph},1),"Example 3b: Ok ordered_graph");

    ok(compare_internal_macro_node_ordered($expected4->{internal_macro_node_ordered},$result4->{internal_macro_node_ordered}),"Example 4: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected4->{all_macro_node},$result4->{all_macro_node}),"Example 4: Ok all_macro_node");
    ok(compare_ordered_graph($expected4->{ordered_graph},$result4->{ordered_graph},1),"Example 4: Ok ordered_graph");

    ok(compare_internal_macro_node_ordered($expected5->{internal_macro_node_ordered},$result5->{internal_macro_node_ordered}),"Example 5: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected5->{all_macro_node},$result5->{all_macro_node}),"Example 5: Ok all_macro_node");
    ok(compare_ordered_graph($expected5->{ordered_graph},$result5->{ordered_graph},1),"Example 5: Ok ordered_graph");

    ok(compare_internal_macro_node_ordered($expected6a->{internal_macro_node_ordered},$result6a->{internal_macro_node_ordered}),"Example 6a: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected6a->{all_macro_node},$result6a->{all_macro_node}),"Example 6a: Ok all_macro_node");
    ok(compare_ordered_graph($expected6a->{ordered_graph},$result6a->{ordered_graph},1),"Example 6a: Ok ordered_graph");

    ok(compare_internal_macro_node_ordered($expected6b->{internal_macro_node_ordered},$result6b->{internal_macro_node_ordered}),"Example 6b: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected6b->{all_macro_node},$result6b->{all_macro_node}),"Example 6b: Ok all_macro_node");
    ok(compare_ordered_graph($expected6b->{ordered_graph},$result6b->{ordered_graph},1),"Example 6b: Ok ordered_graph");

    # expected6b tiene los nombres de las ecuaciones harcoded con 10, en este caso result6b debe ser igual que al result6a
    if (N==10) {
        ok(compare_internal_macro_node_ordered($expected6a->{internal_macro_node_ordered},$result6b->{internal_macro_node_ordered}),"Example 6: Ok internal_macro_node_ordered");
        ok(compare_all_macro_node($expected6a->{all_macro_node},$result6b->{all_macro_node}),"Example 6: Ok all_macro_node");
        ok(compare_ordered_graph($expected6a->{ordered_graph},$result6b->{ordered_graph},1),"Example 6: Ok ordered_graph");
    }

    ok(compare_internal_macro_node_ordered($expected7->{internal_macro_node_ordered},$result7->{internal_macro_node_ordered}),"Example 7: Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected7->{all_macro_node},$result7->{all_macro_node}),"Example 7: Ok all_macro_node");
    ok(compare_ordered_graph($expected7->{ordered_graph},$result7->{ordered_graph},1),"Example 7: Ok ordered_graph");
}

sub test_example_0 {
    my $result = causalize($data_example0);
    warn "result data_example0:" . Dumper($result);

    # my $expected = 

    # ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    # ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    # ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_1 {
    my $result = causalize($data_example1);
    # warn "result data_example1:" . Dumper($result);

    my $expected = {
          'internal_macro_node_ordered' => [
                                             {
                                                'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'end' => 99,
                                                                                                                    'init' => 2
                                                                                                                  }
                                                                                                         },
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'name' => 'a1to'.N_2.',b1to'.N_2.',fi,gi',
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'ran' => {
                                                          'next' => -1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'end' => 1,
                                                          'init' => N_2
                                                        },
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                                'index' => {
                                                    'a' => 0,
                                                    'b' => 0,
                                                }
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'f2',
                                                                'g2'
                                                              ],
                                               'ran' => '',
                                               'var_info' => {
                                                               'a' => [
                                                                        N_1
                                                                      ],
                                                               'b' => [
                                                                        N_1
                                                                      ]
                                                             },
                                               'name' => 'a'.N_1.',b'.N_1.',f2,g2',
                                               'index' => ''
                                             },
                                             {
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {
                                                                             'h2' => {
                                                                                       'a' => {
                                                                                                'ran' => '',
                                                                                                'constant' => [
                                                                                                                100
                                                                                                              ]
                                                                                              },
                                                                                       'c' => {
                                                                                                'ran' => '',
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'name' => 'b'.N.',h2',
                                               'index' => ''
                                             },
                                             {
                                               'name' => 'a'.N.',h1',
                                               'var_solved_in_other_mn' => {},
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ]
                                                             },
                                               'ran' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                                'index' => ''
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'h3'
                                                              ],
                                               'var_info' => {
                                                               'c' => []
                                                             },
                                               'ran' => '',
                                               'name' => 'c,h3',
                                               'index' => ''
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                  'a1to'.N_2,
                                  'b1to'.N_2,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'a'.N_1,
                                  'b'.N_1,
                                  'f2',
                                  'g2'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a'.N,
                                  'h1'
                                ],
                                [
                                  'c',
                                  'h3'
                                ]
                              ],
          'ordered_graph' => [
                               'a1to'.N_2.',b1to'.N_2.',fi,gi -> a'.N_1.',b'.N_1.',f2,g2',
                               'b'.N.',h2 -> a'.N.',h1',
                               'b'.N.',h2 -> c,h3'
                             ]
    };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_2 {
    my $result = causalize($data_example2);
    # warn "result data_example2:" . Dumper($result);
    my $expected = {
          'all_macro_node' => [
                                [
                                  'a'.N_1,
                                  'b'.N_1,
                                  'f2',
                                  'g2'
                                ],
                                [
                                  'a'.N,
                                  'b'.N,
                                  'f3',
                                  'g3'
                                ],
                                [
                                  'a1to'.N_2,
                                  'b1to'.N_2,
                                  'fi',
                                  'gi'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'ran' => '',
                                               'index' => '',
                                               'var_info' => {
                                                               'a' => [
                                                                        N_1
                                                                      ],
                                                               'b' => [
                                                                        N_1
                                                                      ]
                                                             },
                                               'name' => 'a'.N_1.',b'.N_1.',f2,g2',
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
                                                                        N
                                                                      ],
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'ran' => '',
                                               'name' => 'a'.N.',b'.N.',f3,g3',
                                               'var_solved_in_other_mn' => {}
                                             },
                                             {
                                               'name' => 'a1to'.N_2.',b1to'.N_2.',fi,gi',
                                               'ran' => {
                                                          'end' => 1,
                                                          'init' => N_2,
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
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'fi' => {
                                                                                       'a' => {
                                                                                                'constant' => [
                                                                                                                100
                                                                                                              ],
                                                                                                'ran' => ''
                                                                                              }
                                                                                     },
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'init' => 2,
                                                                                                                    'end' => 99
                                                                                                                  }
                                                                                                         },
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                             }
                                           ],
          'ordered_graph' => [
                               'a1to'.N_2.',b1to'.N_2.',fi,gi -> a'.N.',b'.N.',f3,g3',
                               'a1to'.N_2.',b1to'.N_2.',fi,gi -> a'.N_1.',b'.N_1.',f2,g2'
                             ]
    };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_3a {
    my $result = causalize($data_example3a);
    #warn Dumper($result);
    my $expected = {
        'internal_macro_node_ordered' => [
                                             {
                                               'ran' => {
                                                          'end' => N_1,
                                                          'init' => 1,
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ]
                                                        },
                                               'name' => 'a2to'.N.',b1to'.N_1.',fi,gi',
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
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '0' => {
                                                                                                                    'init' => 1,
                                                                                                                    'end' => 99,
                                                                                                                    'vars' => [
                                                                                                                                'a',
                                                                                                                                'b'
                                                                                                                              ]
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     },
                                                                             'fi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '0' => {
                                                                                                                    'init' => 1,
                                                                                                                    'vars' => [
                                                                                                                                'a',
                                                                                                                                'b'
                                                                                                                              ],
                                                                                                                    'end' => 99
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     }
                                                                           },
                                             },
                                             {
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'b'.N.',h2',
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {},
                                             },
                                             {
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
                                               'index' => '',
                                               'var_solved_in_other_mn' => {},
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                  'a2to'.N,
                                  'b1to'.N_1,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a1',
                                  'h1'
                                ]
                              ],
          'ordered_graph' => [
                               'a2to'.N.',b1to'.N_1.',fi,gi -> a1,h1',
                             ]
        };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_3b {
    my $result = causalize($data_example3b);
    # warn Dumper($result);
    my $expected = {
        'internal_macro_node_ordered' => [
                                             {
                                               'ran' => {
                                                          'end' => 1,
                                                          'init' => N_1,
                                                          'next' => -1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ]
                                                        },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi,gi',
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
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'end' => 100,
                                                                                                                    'init' => 2
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     },
                                                                             'fi' => {
                                                                                       'a' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'end' => 100,
                                                                                                                    'init' => 2
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     }
                                                                           },
                                             },
                                             {
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'b'.N.',h2',
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {}
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'name' => 'a'.N.',h1',
                                               'ran' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => ''
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                  'a1to'.N_1,
                                  'b1to'.N_1,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a'.N,
                                  'h1'
                                ]
                              ],
          'ordered_graph' => [
                               'a1to'.N_1.',b1to'.N_1.',fi,gi -> a'.N.',h1',
                             ]
        };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_4 {
    my $result = causalize($data_example4);
    # warn Dumper($result);
    my $expected = {
          'ordered_graph' => [
                               'a2to'.N.',b2to'.N.',fi,gi -> b1,h2'
                             ],
          'all_macro_node' => [
                                [
                                  'a2to'.N,
                                  'b2to'.N,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'a1',
                                  'h1'
                                ],
                                [
                                  'b1',
                                  'h2'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                               'name' => 'a2to'.N.',b2to'.N.',fi,gi',
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'init' => 2,
                                                          'end' => N
                                                        },
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                                'var_solved_in_other_mn' => {
                                                             'gi' => {
                                                                       'b' => {
                                                                                'ran' => {
                                                                                           '-1' => {
                                                                                                     'end' => 99,
                                                                                                     'init' => 1
                                                                                                   }
                                                                                         },
                                                                                'constant' => ''
                                                                              }
                                                                     }
                                                           },

                                             },
                                             {
                                               'var_info' => {
                                                               'a' => [
                                                                        1
                                                                      ]
                                                             },
                                               'index' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                               'ran' => '',
                                               'name' => 'a1,h1',
                                               'var_solved_in_other_mn' => {},
                                             },
                                             {
                                               'index' => '',
                                               'ran' => '',
                                               'name' => 'b1,h2',
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'var_info' => {
                                                               'b' => [
                                                                        1
                                                                      ]
                                                             },
                                                'var_solved_in_other_mn' => {},
                                             }
                                           ],
    };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_4_ab {
    my $result_a = causalize($data_example4a);
    # my $result_b = causalize($data_example4b);

    # warn Dumper($result_a);
    return;
    my $expected = {
          'internal_macro_node_ordered' => [
                                             {
                                               'var_info' => {
                                                               'a' => [
                                                                        2
                                                                      ]
                                                             },
                                               'ran' => '',
                                               'name' => 'a2,gi2',
                                               'equations' => [
                                                                'gi2'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'gi2' => {
                                                                                        'b' => {
                                                                                                 'constant' => [
                                                                                                                 1,
                                                                                                                 2
                                                                                                               ],
                                                                                                 'ran' => ''
                                                                                               }
                                                                                      }
                                                                           },
                                               'index' => ''
                                             },
                                             {
                                               'var_info' => {
                                                               'a' => [
                                                                        1
                                                                      ]
                                                             },
                                               'ran' => '',
                                               'name' => 'a1,h1',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                               'index' => '',
                                               'var_solved_in_other_mn' => {}
                                             },
                                             {
                                               'ran' => '',
                                               'var_info' => {
                                                               'b' => [
                                                                        2
                                                                      ]
                                                             },
                                               'name' => 'b2,h3',
                                               'equations' => [
                                                                'h3'
                                                              ],
                                               'index' => '',
                                               'var_solved_in_other_mn' => {}
                                             },
                                             {
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'var_solved_in_other_mn' => {},
                                               'index' => '',
                                               'ran' => '',
                                               'var_info' => {
                                                               'b' => [
                                                                        1
                                                                      ]
                                                             },
                                               'name' => 'b1,h2'
                                             }
                                           ],
          'topological_sort' => [
                                  {
                                    '4' => [
                                             'b1',
                                             'h2'
                                           ],
                                    '2' => [
                                             'a1',
                                             'h1'
                                           ],
                                    '1' => [
                                             'a2',
                                             'gi2'
                                           ],
                                    '3' => [
                                             'b2',
                                             'h3'
                                           ]
                                  },
                                  {
                                    'order' => [
                                                 4,
                                                 3,
                                                 1,
                                                 2
                                               ]
                                  }
                                ],
          'ordered_graph' => [
                               'a2,gi2 -> b1,h2',
                               'a2,gi2 -> b2,h3'
                             ],
          'all_macro_node' => [
                                [
                                  'a1',
                                  'h1'
                                ],
                                [
                                  'b1',
                                  'h2'
                                ],
                                [
                                  'a2',
                                  'gi2'
                                ],
                                [
                                  'b2',
                                  'h3'
                                ]
                              ],
        };

    # ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result_a->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    # ok(compare_all_macro_node($expected->{all_macro_node},$result_a->{all_macro_node}),"Ok all_macro_node");
    # ok(compare_ordered_graph($expected->{ordered_graph},$result_a->{ordered_graph},1),"Ok ordered_graph");

    # ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result_b->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    # ok(compare_all_macro_node($expected->{all_macro_node},$result_b->{all_macro_node}),"Ok all_macro_node");
    # ok(compare_ordered_graph($expected->{ordered_graph},$result_b->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_5 {
    my $result = causalize($data_example5);warn Dumper($result);
    my $expected =  {
          'all_macro_node' => [
                                [
                                  'a2to'.N,
                                  'b1to'.N_1,
                                  'fi',
                                  'gi'
                                ],
                                [
                                  'b'.N,
                                  'h2'
                                ],
                                [
                                  'a1',
                                  'h1'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                               'ran' => {
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'next' => 1,
                                                          'end' => N_1,
                                                          'init' => 1
                                                        },
                                               'name' => 'a2to'.N.',b1to'.N_1.',fi,gi',
                                               'index' => {
                                                            'b' => 0,
                                                            'a' => 1
                                                          },
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                                'var_solved_in_other_mn' => {},
                                             },
                                             {
                                               'equations' => [
                                                                'h2'
                                                              ],
                                               'ran' => '',
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'name' => 'b'.N.',h2',
                                               'index' => '',
                                                'var_solved_in_other_mn' => {},
                                             },
                                             {
                                               'ran' => '',
                                               'name' => 'a1,h1',
                                               'index' => '',
                                               'var_info' => {
                                                               'a' => [
                                                                        1
                                                                      ]
                                                             },
                                               'equations' => [
                                                                'h1'
                                                              ],
                                             'var_solved_in_other_mn' => {},
                                             },
                                           ],
          'ordered_graph' => []
    };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_6a {
    my $result = causalize($data_example6a);
    warn Dumper($result);
    # return;
    my $expected =  {
          'all_macro_node' => [
                                [
                                  'a1to'.N_1,
                                  'b1to'.N_1,
                                  'fi1'.N_1,
                                  'gi1'.N_1
                                ],
                                [
                                  'c1to'.N_1,
                                  'hi1'.N_1
                                ],
                                [
                                  'a'.N,
                                  'b'.N,
                                  'fi'.N,
                                  'gi'.N
                                ],
                                [
                                  'c'.N,
                                  'k10'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi1'.N_1.',gi1'.N_1,
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                               'ran' => {
                                                          'end' => N_1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'next' => 1,
                                                          'init' => 1
                                                        },
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi1'.N_1,
                                                                'gi1'.N_1
                                                              ]
                                             },
                                             {
                                               'index' => {
                                                            'c' => 0
                                                          },
                                               'name' => 'c1to'.N_1.',hi1'.N_1,
                                               'var_info' => {
                                                               'c' => ''
                                                             },
                                               'equations' => [
                                                                'hi1'.N_1
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'hi1'.N_1 => {
                                                                                         'a' => {
                                                                                                  'ran' => {
                                                                                                             '1' => {
                                                                                                                      'end' => N,
                                                                                                                      'init' => 2
                                                                                                                    }
                                                                                                           },
                                                                                                  'constant' => ''
                                                                                                },
                                                                                         'b' => {
                                                                                                  'constant' => '',
                                                                                                  'ran' => {
                                                                                                             '0' => {
                                                                                                                      'end' => N_1,
                                                                                                                      'vars' => [
                                                                                                                                  'a',
                                                                                                                                  'b',
                                                                                                                                  'c'
                                                                                                                                ],
                                                                                                                      'init' => 1
                                                                                                                    }
                                                                                                           }
                                                                                                }
                                                                                       }
                                                                           },
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'c'
                                                                    ],
                                                          'end' => N_1,
                                                          'init' => 1
                                                        }
                                             },
                                             {
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi'.N,
                                                                'gi'.N
                                                              ],
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ],
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'a'.N.',b'.N.',fi'.N.',gi'.N
                                             },
                                             {
                                               'var_info' => {
                                                               'c' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'c'.N.',k10',
                                               'ran' => '',
                                               'equations' => [
                                                                'k10'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'k10' => {
                                                                                        'b' => {
                                                                                                 'ran' => '',
                                                                                                 'constant' => [
                                                                                                                 N
                                                                                                               ]
                                                                                               }
                                                                                      }
                                                                           }
                                             }
                                           ],
          'ordered_graph' => [
                               'c1to'.N_1.',hi1'.N_1.' -> a1to'.N_1.',b1to'.N_1.',fi1'.N_1.',gi1'.N_1,
                               'c1to'.N_1.',hi1'.N_1.' -> a'.N.',b'.N.',fi'.N.',gi'.N,
                               'c'.N.',k10 -> a'.N.',b'.N.',fi'.N.',gi'.N
                             ],
    };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}

sub test_example_6b {
    my $result = causalize($data_example6b);
    # warn Dumper($result);
    # return;
    my $expected =  {
          'all_macro_node' => [
                                [
                                  'a1to'.N_1,
                                  'b1to'.N_1,
                                  'fi19',
                                  'gi19'
                                ],
                                [
                                  'c1to'.N_1,
                                  'hi19'
                                ],
                                [
                                  'a'.N,
                                  'b'.N,
                                  'fi10',
                                  'gi10'
                                ],
                                [
                                  'c'.N,
                                  'k10'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi19,gi19',
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                               'ran' => {
                                                          'end' => N_1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ],
                                                          'next' => 1,
                                                          'init' => 1
                                                        },
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi19',
                                                                'gi19'
                                                              ]
                                             },
                                             {
                                               'index' => {
                                                            'c' => 0
                                                          },
                                               'name' => 'c1to'.N_1.',hi19',
                                               'var_info' => {
                                                               'c' => ''
                                                             },
                                               'equations' => [
                                                                'hi19'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'hi19' => {
                                                                                         'a' => {
                                                                                                  'ran' => {
                                                                                                             '1' => {
                                                                                                                      'end' => N,
                                                                                                                      'init' => 2
                                                                                                                    }
                                                                                                           },
                                                                                                  'constant' => ''
                                                                                                },
                                                                                         'b' => {
                                                                                                  'constant' => '',
                                                                                                  'ran' => {
                                                                                                             '0' => {
                                                                                                                      'end' => N_1,
                                                                                                                      'vars' => [
                                                                                                                                  'a',
                                                                                                                                  'b',
                                                                                                                                  'c'
                                                                                                                                ],
                                                                                                                      'init' => 1
                                                                                                                    }
                                                                                                           }
                                                                                                }
                                                                                       }
                                                                           },
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'c'
                                                                    ],
                                                          'end' => N_1,
                                                          'init' => 1
                                                        }
                                             },
                                             {
                                               'ran' => '',
                                               'var_solved_in_other_mn' => {},
                                               'equations' => [
                                                                'fi10',
                                                                'gi10'
                                                              ],
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ],
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'a'.N.',b'.N.',fi10,gi10'
                                             },
                                             {
                                               'var_info' => {
                                                               'c' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => '',
                                               'name' => 'c'.N.',k10',
                                               'ran' => '',
                                               'equations' => [
                                                                'k10'
                                                              ],
                                               'var_solved_in_other_mn' => {
                                                                             'k10' => {
                                                                                        'b' => {
                                                                                                 'ran' => '',
                                                                                                 'constant' => [
                                                                                                                 N
                                                                                                               ]
                                                                                               }
                                                                                      }
                                                                           }
                                             }
                                           ],
          'ordered_graph' => [
                               'c1to'.N_1.',hi19 -> a1to'.N_1.',b1to'.N_1.',fi19,gi19',
                               'c1to'.N_1.',hi19 -> a'.N.',b'.N.',fi10,gi10',
                               'c'.N.',k10 -> a'.N.',b'.N.',fi10,gi10'
                             ],
    };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
}
# Example 7
# model a
#     Real a[N],b[N],c,d;
# equation
#     for i in 1:N-1 loop
#         a[i]*b[i]+c=0;        fi
#         a[i]*b[i]*b[i+1]=6;   gi
#     end for;
#     a[N]+d=2;               h1
#     b[N]=4;                 h2
#     c=10;                   h3
#     d=20;                   h4
# end a;
sub test_example_7 {
    my $result = causalize($data_example7);
    warn Dumper($result);
    # return;
    my $expected = {
          'ordered_graph' => [
                               'a1to'.N_1.',b1to'.N_1.',fi,gi -> b'.N.',h2',
                               'a1to'.N_1.',b1to'.N_1.',fi,gi -> c,h3',
                               'a'.N.',h1 -> d,h4'
                             ],
          'topological_sort' => [
                                  {
                                    '5' => [
                                             'c',
                                             'h3'
                                           ],
                                    '2' => [
                                             'd',
                                             'h4'
                                           ],
                                    '3' => [
                                             'a'.N,
                                             'h1'
                                           ],
                                    '4' => [
                                             'b'.N,
                                             'h2'
                                           ],
                                    '1' => [
                                             'a1to'.N_1,
                                             'b1to'.N_1,
                                             'fi',
                                             'gi'
                                           ]
                                  },
                                  {
                                    'order' => [
                                                 2,
                                                 3,
                                                 4,
                                                 5,
                                                 1
                                               ]
                                  }
                                ],
          'internal_macro_node_ordered' => [
                                             {
                                               'index' => {
                                                            'a' => 0,
                                                            'b' => 0
                                                          },
                                               'var_info' => {
                                                               'b' => '',
                                                               'a' => ''
                                                             },
                                               'var_solved_in_other_mn' => {
                                                                             'gi' => {
                                                                                       'b' => {
                                                                                                'constant' => '',
                                                                                                'ran' => {
                                                                                                           '1' => {
                                                                                                                    'init' => 2,
                                                                                                                    'end' => N
                                                                                                                  }
                                                                                                         }
                                                                                              }
                                                                                     },
                                                                             'fi' => {
                                                                                       'c' => {
                                                                                                'ran' => '',
                                                                                                'constant' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'name' => 'a1to'.N_1.',b1to'.N_1.',fi,gi',
                                               'equations' => [
                                                                'fi',
                                                                'gi'
                                                              ],
                                               'ran' => {
                                                          'end' => 1,
                                                          'next' => -1,
                                                          'init' => N_1,
                                                          'vars' => [
                                                                      'a',
                                                                      'b'
                                                                    ]
                                                        }
                                             },
                                             {
                                               'equations' => [
                                                                'h4'
                                                              ],
                                               'ran' => '',
                                               'index' => '',
                                               'name' => 'd,h4',
                                               'var_solved_in_other_mn' => {},
                                               'var_info' => {
                                                               'd' => []
                                                             }
                                             },
                                             {
                                               'ran' => '',
                                               'equations' => [
                                                                'h1'
                                                              ],
                                               'name' => 'a'.N.',h1',
                                               'var_solved_in_other_mn' => {
                                                                             'h1' => {
                                                                                       'd' => {
                                                                                                'constant' => '',
                                                                                                'ran' => ''
                                                                                              }
                                                                                     }
                                                                           },
                                               'var_info' => {
                                                               'a' => [
                                                                        N
                                                                      ]
                                                             },
                                               'index' => ''
                                             },
                                             {
                                               'var_solved_in_other_mn' => {},
                                               'var_info' => {
                                                               'b' => [
                                                                        N
                                                                      ]
                                                             },
                                               'name' => 'b'.N.',h2',
                                               'index' => '',
                                               'ran' => '',
                                               'equations' => [
                                                                'h2'
                                                              ]
                                             },
                                             {
                                               'ran' => '',
                                               'equations' => [
                                                                'h3'
                                                              ],
                                               'name' => 'c,h3',
                                               'var_info' => {
                                                               'c' => []
                                                             },
                                               'var_solved_in_other_mn' => {},
                                               'index' => ''
                                             }
                                           ],
          'all_macro_node' => [
                                [
                                 'a1to'.N_1,
                                 'b1to'.N_1,
                                 'fi',
                                 'gi'
                                ],
                                [
                                 'd',
                                 'h4'
                                ],
                                [
                                 'a'.N,
                                 'h1'
                                ],
                                [
                                 'b'.N,
                                 'h2'
                                ],
                                [
                                 'c',
                                 'h3'
                                ]
                              ]
    };

    ok(compare_internal_macro_node_ordered($expected->{internal_macro_node_ordered},$result->{internal_macro_node_ordered}),"Ok internal_macro_node_ordered");
    ok(compare_all_macro_node($expected->{all_macro_node},$result->{all_macro_node}),"Ok all_macro_node");
    ok(compare_ordered_graph($expected->{ordered_graph},$result->{ordered_graph},1),"Ok ordered_graph");
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