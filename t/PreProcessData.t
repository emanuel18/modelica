
use Data::Dumper;
use lib "/Users/emanuel/Documents/personal/facultad/causalize/5";

use strict;
use warnings;
use 5.010;
 
use Test::Simple;
use Test::More;
use constant N => 10;

use PreProcessData qw(pre_process_data);


# Example 1a
# equation
#   for i in 1:10 loop
#       a[i]*b[i]=1;         fi
#       a[i]+b[i]^2=0;       gi
#   end for;
#     for i in 1:9 loop
#       c[i]=a[i+1]+3*b[i];  hi
#     end for;
#     c[10]=3*b[10];         k10
# end Ejemplo;

our $data_example1a = {
    fi => {
        ran => { 
            0 => {
                init => 1,
                end  => 10,
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
                end  => 10,
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
                end  => 9,
                vars => ['a','b','c'] # aca no va a xq el indice de a es i+1 solamente, entonces no esta dentro del for
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

# Example 1b
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

our $data_example1b = {
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
    fi10 => {
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
    gi10 => {
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

&main();

sub main {

    # test_example_1();
my $status = 1;
    if($status) {
        warn "si";
    }
    else {
        warn "nooo";
    }
}

sub test_example_1 {
    pre_process_data($data_example1a);

    is_deeply($data_example1a,$data_example1b,"Ok pre process data");
}

1;