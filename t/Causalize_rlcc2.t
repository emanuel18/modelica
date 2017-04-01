
use Data::Dumper;
use lib "/Users/emanuel/Documents/personal/facultad/causalize/5";

use strict;
use warnings;
use 5.010;
 
use Test::Simple;
use Test::More;
use constant N => 5;

use Causalize qw(causalize);

# original
# model RLCC2
#   constant Integer N = 5;
#   parameter Real R=1,L=1,C=1,Vs=1;
#   Real Ir3[N], Il[N], Uc1[N], Ua[N], Ir1[N], Uc2[N];
#   Real Vr, Ir;
# equation
#   L*der(Il[1]) = Vs - Ua[1];
#   C*der(Uc2[N]) = Ir3[N] - Ir;
  
#   for i in 1:N loop
#     Ir1[i] = (Ua[i] - Uc1[i])/R;
#     Ir3[i] = (Ua[i] - Uc2[i])/R;
#     Il[i] = Ir1[i] + Ir3[i];
#     C*der(Uc1[i]) = Ir1[i];
#   end for;
#   for i in 1:N-1 loop
#     C*der(Uc2[i]) = Ir3[i] - Il[i+1];
#     L*der(Il[i+1]) = Uc2[i];
#   end for;
#   Vr = R*Ir;
#   Uc2[N] = Vr;
# end RLCC2;

# Example 4
# 'Il2to11,g2 -> Il1,f1';
# model RLCC2
#   constant Integer N = 5;
#   parameter Real R=1,L=1,C=1,Vs=1;
#   Real Ir3[N], Il[N], Uc1[N], Ua[N], Ir1[N], Uc2[N];
#   Real Vr, Ir;
# equation
#   L*der(Il[1]) = 1 - Ua[1];           f1     
#   C*der(Uc2[N]) = Ir3[N] - Ir;         f2
#   Vr = R*Ir;                           f3
#   Uc2[N] = Vr;                         f4

#   for i in 1:N loop
#     Ir1[i] = (Ua[i] - Uc1[i])/R;       h1
#     Ir3[i] = (Ua[i] - Uc2[i])/R;       h2
#     Il[i] = Ir1[i] + Ir3[i];           h3
#     C*der(Uc1[i]) = Ir1[i];            h4
#   end for; 
#   for i in 1:N-1 loop
#     C*der(Uc2[i]) = Ir3[i] - Il[i+1];  g1
#     L*der(Il[i+1]) = Uc2[i];           g2
#   end for;
# end RLCC2;


# # model RLCC2
# #   constant Integer N = 5;
# #   parameter Real R=1,L=1,C=1,Vs=1;
# #   Real Ir3[N], Il[N], Uc1[N], Ua[N], Ir1[N], Uc2[N];
# #   Real Vr, Ir;
# # equation
# #   L*der(Il[1]) = Vs - Ua[1];           f1     
# #   C*der(Uc2[N]) = Ir3[N] - Ir;         f2
# #   Ir1[1] = (Ua[1] - Uc1[1])/R;       h11
# #   Ir3[1] = (Ua[1] - Uc2[1])/R;       h21
# #   Il[1] = Ir1[1] + Ir3[1];           h31
# #   C*der(Uc1[1]) = Ir1[1];            h41
# #   C*der(Uc2[1]) = Ir3[1] - Il[2];  g11
# #   L*der(Il[2]) = Uc2[1];           g21

# #   for i in 2:N loop
# #     Ir1[i] = (Ua[i] - Uc1[i])/R;       h1
# #     Ir3[i] = (Ua[i] - Uc2[i])/R;       h2
# #     Il[i] = Ir1[i] + Ir3[i];           h3
# #     C*der(Uc1[i]) = Ir1[i];            h4
# #   end for; 
# #   for i in 2:N-1 loop
# #     C*der(Uc2[i]) = Ir3[i] - Il[i+1];  g1
# #     L*der(Il[i+1]) = Uc2[i];           g2
# #   end for;
# #   Vr = R*Ir;                           k1
# #   Uc2[N] = Vr;                         k2
# # end RLCC2;
our $data_example = {
    f1 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },
        }, 
    },
    f2 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [N]
            },
            Ir3 => {
                ran      => "",
                constant => [N]
            },            
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    h11 => {
        ran => "",
        var_info => {
            Ir1 => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },            
            Uc1 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h21 => {
        ran => "",
        var_info => {
            Ir3 => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },            
            Uc2 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h31 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [1]
            },
            Ir1 => {
                ran      => "",
                constant => [1]
            },            
            Ir3 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h41 => {
        ran => "",
        var_info => {
            Uc1 => {
                ran      => "",
                constant => [1]
            },
            Ir1 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h1 => {
        ran => {
            0 => {
                init => 2,
                end  => N,
                vars => ['Ir1','Ua','Uc1']
            }
        },
        var_info => {
            Ir1 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
            Uc1 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h2 => {
        ran => {
            0 => {
                init => 2,
                end  => N,
                vars => ['Ir3','Ua','Uc2']
            }
        },
        var_info => {
            Ir3 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
            Uc2 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h3 => {
        ran => {
            0 => {
                init => 2,
                end  => N,
                vars => ['Il','Ir1','Ir3']
            }
        },
        var_info => {
            Il => {
                ran      => "",
                constant => ""
            },
            Ir1 => {
                ran      => "",
                constant => ""
            },            
            Ir3 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h4 => {
        ran => {
            0 => {
                init => 2,
                end  => N,
                vars => ['Uc1','Ir1']
            }
        },
        var_info => {
            Uc1 => {
                ran      => "",
                constant => ""
            },
            Ir1 => {
                ran      => "",
                constant => ""
            },
        },
    },
    g11 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [1]
            },
            Ir3 => {
                ran      => "",
                constant => [1]
            },            
            Il => {
                ran      => "",
                constant => [2]
            },
        },
    },
    g21 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [2]
            },          
            Uc2 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    g1 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Uc2','Ir3','Il']
            }
        },
        var_info => {
            Uc2 => {
                ran      => "",
                constant => ""
            },
            Ir3 => {
                ran      => "",
                constant => ""
            },            
            Il => {
                ran      => {
                    1 => {
                        init => 3,
                        end  => N,
                    }
                },
                constant => ""
            },
        },
    },
    g2 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Il','Uc2']
            }
        },
        var_info => {
            Il => {
                ran      => {
                    1 => {
                        init => 3,
                        end  => N,
                    }
                },
                constant => ""
            },          
            Uc2 => {
                ran      => "",
                constant => ""
            },
        },
    },
    k1 => {
        ran => "",
        var_info => {
            Vr => {
                ran      => "",
                constant => ""
            },
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    k2 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [N]
            },
            Vr => {
                ran      => "",
                constant => ""
            },
        }, 
    },
};

# model RLCC2
#   constant Integer N = 5;
#   parameter Real R=1,L=1,C=1,Vs=1;
#   Real Ir3[N], Il[N], Uc1[N], Ua[N], Ir1[N], Uc2[N];
#   Real Vr, Ir;
# equation
#   L*der(Il[1]) = Vs - Ua[1];         f1     
#   Ir1[1] = (Ua[1] - Uc1[1])/R;       h11
#   Ir3[1] = (Ua[1] - Uc2[1])/R;       h21
#   Il[1] = Ir1[1] + Ir3[1];           h31
#   C*der(Uc1[1]) = Ir1[1];            h41
#   C*der(Uc2[1]) = Ir3[1] - Il[2];  g11
#   L*der(Il[2]) = Uc2[1];           g21 

#   C*der(Uc2[N]) = Ir3[N] - Ir;       f2
#   Ir1[N] = (Ua[N] - Uc1[N])/R;       h1N
#   Ir3[N] = (Ua[N] - Uc2[N])/R;       h2N
#   Il[N] = Ir1[N] + Ir3[N];           h3N  #Il[N] se resuelve en el loop siguiente, dentro de g1 y g2 con Il(i+1)
#   C*der(Uc1[N]) = Ir1[N];            h4N
#   Vr = R*Ir;                           k1
#   Uc2[N] = Vr;                         k2

#   for i in 2:N-1 loop
#     Ir1[i] = (Ua[i] - Uc1[i])/R;+       h1
#     Ir3[i] = (Ua[i] - Uc2[i])/R;       h2
#     Il[i] = Ir1[i] + Ir3[i];           h3  #cuando i=2 h3 necesita que Il[2] este resuelto, el cual esta en g21
#     C*der(Uc1[i]) = Ir1[i];            h4
#     C*der(Uc2[i]) = Ir3[i] - Il[i+1];  g1
#     L*der(Il[i+1]) = Uc2[i];           g2
#   end for;

# end RLCC2;
our $data_rlcc2 = {
    f1 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },
        }, 
    },
    f2 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [N]
            },
            Ir3 => {
                ran      => "",
                constant => [N]
            },            
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    h11 => {
        ran => "",
        var_info => {
            Ir1 => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },            
            Uc1 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h21 => {
        ran => "",
        var_info => {
            Ir3 => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },            
            Uc2 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h31 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [1]
            },
            Ir1 => {
                ran      => "",
                constant => [1]
            },            
            Ir3 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h41 => {
        ran => "",
        var_info => {
            Uc1 => {
                ran      => "",
                constant => [1]
            },
            Ir1 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    g11 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [1]
            },
            Ir3 => {
                ran      => "",
                constant => [1]
            },            
            Il => {
                ran      => "",
                constant => [2]
            },
        },
    },
    g21 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [2]
            },          
            Uc2 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h1N => {
        ran => "",
        var_info => {
            Ir1 => {
                ran      => "",
                constant => [N]
            },
            Ua => {
                ran      => "",
                constant => [N]
            },            
            Uc1 => {
                ran      => "",
                constant => [N]
            },
        },
    },
    h2N => {
        ran => "",
        var_info => {
            Ir3 => {
                ran      => "",
                constant => [N]
            },
            Ua => {
                ran      => "",
                constant => [N]
            },            
            Uc2 => {
                ran      => "",
                constant => [N]
            },
        },
    },
    h3N => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [N]
            },
            Ir1 => {
                ran      => "",
                constant => [N]
            },            
            Ir3 => {
                ran      => "",
                constant => [N]
            },
        },
    },
    h4N => {
        ran => "",
        var_info => {
            Uc1 => {
                ran      => "",
                constant => [N]
            },
            Ir1 => {
                ran      => "",
                constant => [N]
            },
        },
    },
    h1 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Ir1','Ua','Uc1']
            }
        },
        var_info => {
            Ir1 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
            Uc1 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h2 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Ir3','Ua','Uc2']
            }
        },
        var_info => {
            Ir3 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
            Uc2 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h3 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Il','Ir1','Ir3']
            }
        },
        var_info => {
            Il => {
                ran      => "",
                constant => ""
            },
            Ir1 => {
                ran      => "",
                constant => ""
            },            
            Ir3 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h4 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Uc1','Ir1']
            }
        },
        var_info => {
            Uc1 => {
                ran      => "",
                constant => ""
            },
            Ir1 => {
                ran      => "",
                constant => ""
            },
        },
    },
    g1 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Uc2','Ir3','Il']
            }
        },
        var_info => {
            Uc2 => {
                ran      => "",
                constant => ""
            },
            Ir3 => {
                ran      => "",
                constant => ""
            },            
            Il => {
                ran      => {
                    1 => {
                        init => 3,
                        end  => N,
                    }
                },
                constant => ""
            },
        },
    },
    g2 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Il','Uc2']
            }
        },
        var_info => {
            Il => {
                ran      => {
                    1 => {
                        init => 3,
                        end  => N,
                    }
                },
                constant => ""
            },          
            Uc2 => {
                ran      => "",
                constant => ""
            },
        },
    },
    k1 => {
        ran => "",
        var_info => {
            Vr => {
                ran      => "",
                constant => ""
            },
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    k2 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [N]
            },
            Vr => {
                ran      => "",
                constant => ""
            },
        }, 
    },
};

# rlcc corregido con fede bergero
our $data_rlcc22 = {
    f1 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },
        }, 
    },
    f2 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [N]
            },
            Ir3 => {
                ran      => "",
                constant => [N]
            },            
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    h11 => {
        ran => "",
        var_info => {
            Ir1 => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },            
        },
    },
    h21 => {
        ran => "",
        var_info => {
            Ir3 => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },
        },
    },
    h31 => {
        ran => "",
        var_info => {
            Ir1 => {
                ran      => "",
                constant => [1]
            },            
            Ir3 => {
                ran      => "",
                constant => [1]
            }
        },
    },
    h41 => {
        ran => "",
        var_info => {
            Uc1 => {
                ran      => "",
                constant => [1]
            },
            Ir1 => {
                ran      => "",
                constant => [1]
            },
        },
    },
    g11 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [1]
            },
            Ir3 => {
                ran      => "",
                constant => [1]
            },        
        },
    },
    g21 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [2]
            },          
        },
    },
    h1N => {
        ran => "",
        var_info => {
            Ir1 => {
                ran      => "",
                constant => [N]
            },
            Ua => {
                ran      => "",
                constant => [N]
            },            
        },
    },
    h2N => {
        ran => "",
        var_info => {
            Ir3 => {
                ran      => "",
                constant => [N]
            },
            Ua => {
                ran      => "",
                constant => [N]
            },            
        },
    },
    h3N => {
        ran => "",
        var_info => {
            Ir1 => {
                ran      => "",
                constant => [N]
            },            
            Ir3 => {
                ran      => "",
                constant => [N]
            },
        },
    },
    h4N => {
        ran => "",
        var_info => {
            Uc1 => {
                ran      => "",
                constant => [N]
            },
            Ir1 => {
                ran      => "",
                constant => [N]
            },
        },
    },
    h1 => {
        ran => {
            0 => {
                init => 1,
                end  => N-1,
                vars => ['Ir1','Ua','Uc1']
            }
        },
        var_info => {
            Ir1 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
        },
    },
    h2 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Ir3','Ua','Uc2']
            }
        },
        var_info => {
            Ir3 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
        },
    },
    h3 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Il','Ir1','Ir3']
            }
        },
        var_info => {
            Ir1 => {
                ran      => "",
                constant => ""
            },            
            Ir3 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h4 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Uc1','Ir1']
            }
        },
        var_info => {
            Uc1 => {
                ran      => "",
                constant => ""
            },
            Ir1 => {
                ran      => "",
                constant => ""
            },
        },
    },
    g1 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Uc2','Ir3','Il']
            }
        },
        var_info => {
            Uc2 => {
                ran      => "",
                constant => ""
            },
            Ir3 => {
                ran      => "",
                constant => ""
            },            
        },
    },
    g2 => {
        ran => {
            0 => {
                init => 2,
                end  => N-1,
                vars => ['Il','Uc2']
            }
        },
        var_info => {
            Il => {
                ran      => {
                    1 => {
                        init => 3,
                        end  => N,
                    }
                },
                constant => ""
            },          
        },
    },
    k1 => {
        ran => "",
        var_info => {
            Vr => {
                ran      => "",
                constant => ""
            },
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    k2 => {
        ran => "",
        var_info => {
            Vr => {
                ran      => "",
                constant => ""
            },
        }, 
    },
};

# original
# model RLCC2
#   constant Integer N = 5;
#   parameter Real R=1,L=1,C=1,Vs=1;
#   Real Ir3[N], Il[N], Uc1[N], Ua[N], Ir1[N], Uc2[N];
#   Real Vr, Ir;
# equation
#   L*der(Il[1]) = Vs - Ua[1];           f1
#   C*der(Uc2[N]) = Ir3[N] - Ir;         f2
  
#   for i in 1:N loop
#     Ir1[i] = (Ua[i] - Uc1[i])/R;       g1i  # saco Uc1[i]
#     Ir3[i] = (Ua[i] - Uc2[i])/R;       g2i  # saco Uc2[i]
#     Il[i] = Ir1[i] + Ir3[i];           g3i  # saco Il[i]
#     C*der(Uc1[i]) = Ir1[i];            g4i
#   end for;
#   for i in 1:N-1 loop
#     C*der(Uc2[i]) = Ir3[i] - Il[i+1];  h1i  # saco Il[i+1]
#     L*der(Il[i+1]) = Uc2[i];           h2i  # saco Uc2[i]
#   end for;
#   Vr = R*Ir;                           k1
#   Uc2[N] = Vr;                         k2   # saco Uc2[N]
# end RLCC2;

our $data_rlcc2_original = {
    f1 => {
        ran => "",
        var_info => {
            Il => {
                ran      => "",
                constant => [1]
            },
            Ua => {
                ran      => "",
                constant => [1]
            },
        }, 
    },
    f2 => {
        ran => "",
        var_info => {
            Uc2 => {
                ran      => "",
                constant => [N]
            },
            Ir3 => {
                ran      => "",
                constant => [N]
            },            
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    g1i => {
        ran => {
            0 => {
                init => 1,
                end  => N,
                vars => ['Ir1','Ua']
            }
        },
        var_info => {
            Ir1 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
        },
    },
    g2i => {
        ran => {
            0 => {
                init => 1,
                end  => N,
                vars => ['Ir3','Ua']
            }
        },
        var_info => {
            Ir3 => {
                ran      => "",
                constant => ""
            },
            Ua => {
                ran      => "",
                constant => ""
            },            
        },
    },
    g3i => {
        ran => {
            0 => {
                init => 1,
                end  => N,
                vars => ['Ir1','Ir3']
            }
        },
        var_info => {
            Ir1 => {
                ran      => "",
                constant => ""
            },            
            Ir3 => {
                ran      => "",
                constant => ""
            },
        },
    },
    g4i => {
        ran => {
            0 => {
                init => 1,
                end  => N,
                vars => ['Uc1','Ir1']
            }
        },
        var_info => {
            Uc1 => {
                ran      => "",
                constant => ""
            },
            Ir1 => {
                ran      => "",
                constant => ""
            },
        },
    },
    h1i => {
        ran => {
            0 => {
                init => 1,
                end  => N-1,
                vars => ['Uc2','Ir3']
            }
        },
        var_info => {
            Uc2 => {
                ran      => "",
                constant => ""
            },
            Ir3 => {
                ran      => "",
                constant => ""
            },            
        },
    },
    h2i => {
        ran => {
            0 => {
                init => 1,
                end  => N-1,
                vars => ['Il']
            }
        },
        var_info => {
            Il => {
                ran      => {
                    1 => {
                        init => 2,
                        end  => N,
                    }
                },
                constant => ""
            },          
        },
    },
    k1 => {
        ran => "",
        var_info => {
            Vr => {
                ran      => "",
                constant => ""
            },
            Ir => {
                ran      => "",
                constant => ""
            },
        }, 
    },
    k2 => {
        ran => "",
        var_info => {
            Vr => {
                ran      => "",
                constant => ""
            },
        }, 
    },
};

# modified por el algoritmo
# model RLCC2
#   constant Integer N = 5;
#   parameter Real R=1,L=1,C=1,Vs=1;
#   Real Ir3[N], Il[N], Uc1[N], Ua[N], Ir1[N], Uc2[N];
#   Real Vr, Ir;
# equation
#   L*der(Il[1]) = Vs - Ua[1];           f1
#   C*der(Uc2[N]) = Ir3[N] - Ir;         f2
  
#   for i in 1:N-1 loop
#     Ir1[i] = (Ua[i] - Uc1[i])/R;       g1i  # saco Uc1[i]
#     Ir3[i] = (Ua[i] - Uc2[i])/R;       g2i  # saco Uc2[i]
#     Il[i] = Ir1[i] + Ir3[i];           g3i  # saco Il[i]
#     C*der(Uc1[i]) = Ir1[i];            g4i
#   end for;

#     Ir1[N] = (Ua[N] - Uc1[N])/R;       g1i5  # saco Uc1[i]
#     Ir3[N] = (Ua[N] - Uc2[N])/R;       g2i5  # saco Uc2[i]
#     Il[N] = Ir1[N] + Ir3[N];           g3i5  # saco Il[i]
#     C*der(Uc1[N]) = Ir1[N];            g4i5

#   for i in 1:N-1 loop
#     C*der(Uc2[i]) = Ir3[i] - Il[i+1];  h1i  # saco Il[i+1]
#     L*der(Il[i+1]) = Uc2[i];           h2i  # saco Uc2[i]
#   end for;
#   Vr = R*Ir;                           k1
#   Uc2[N] = Vr;                         k2   # saco Uc2[N]
# end RLCC2;

our $data_rlcc2_modified = {
    'f1' => {
            'var_info' => {
                            'Ua' => {
                                      'ran' => '',
                                      'constant' => [
                                                      1
                                                    ]
                                    },
                            'Il' => {
                                      'constant' => [
                                                      1
                                                    ],
                                      'ran' => ''
                                    }
                          },
            'ran' => ''
          },
    'f2' => {
            'var_info' => {
                            'Ir3' => {
                                       'ran' => '',
                                       'constant' => [
                                                       5
                                                     ]
                                     },
                            'Ir' => {
                                      'ran' => '',
                                      'constant' => ''
                                    },
                            'Uc2' => {
                                       'ran' => '',
                                       'constant' => [
                                                       5
                                                     ]
                                     }
                          },
            'ran' => ''
          },
    'g1i14' => {
             'ran' => {
                        '0' => {
                                 'init' => 1,
                                 'end' => 4,
                                 'vars' => [
                                             'Ir1',
                                             'Ua'
                                           ]
                               }
                      },
             'var_info' => {
                             'Ir1' => {
                                        'constant' => '',
                                        'ran' => ''
                                      },
                             'Ua' => {
                                       'constant' => '',
                                       'ran' => ''
                                     }
                           }
           },
    'g1i5' => {
              'ran' => '',
              'var_info' => {
                              'Ua' => {
                                        'constant' => [
                                                        5
                                                      ],
                                        'ran' => ''
                                      },
                              'Ir1' => {
                                         'constant' => [
                                                         5
                                                       ],
                                         'ran' => ''
                                       }
                            }
            },
    'g2i14' => {
             'ran' => {
                        '0' => {
                                 'end' => 4,
                                 'init' => 1,
                                 'vars' => [
                                             'Ir3',
                                             'Ua'
                                           ]
                               }
                      },
             'var_info' => {
                             'Ua' => {
                                       'ran' => '',
                                       'constant' => ''
                                     },
                             'Ir3' => {
                                        'constant' => '',
                                        'ran' => ''
                                      }
                           }
           },
    'g2i5' => {
              'ran' => '',
              'var_info' => {
                              'Ua' => {
                                        'ran' => '',
                                        'constant' => [
                                                        5
                                                      ]
                                      },
                              'Ir3' => {
                                         'ran' => '',
                                         'constant' => [
                                                         5
                                                       ]
                                       }
                            }
            },
    'g3i14' => {
             'var_info' => {
                             'Ir1' => {
                                        'constant' => '',
                                        'ran' => ''
                                      },
                             'Ir3' => {
                                        'ran' => '',
                                        'constant' => ''
                                      }
                           },
             'ran' => {
                        '0' => {
                                 'vars' => [
                                             'Ir1',
                                             'Ir3'
                                           ],
                                 'end' => 4,
                                 'init' => 1
                               }
                      }
           },
    'g3i5' => {
              'var_info' => {
                              'Ir1' => {
                                         'ran' => '',
                                         'constant' => [
                                                         5
                                                       ]
                                       },
                              'Ir3' => {
                                         'constant' => [
                                                         5
                                                       ],
                                         'ran' => ''
                                       }
                            },
              'ran' => ''
            },
    'g4i14' => {
             'ran' => {
                        '0' => {
                                 'init' => 1,
                                 'end' => 4,
                                 'vars' => [
                                             'Uc1',
                                             'Ir1'
                                           ]
                               }
                      },
             'var_info' => {
                             'Uc1' => {
                                        'constant' => '',
                                        'ran' => ''
                                      },
                             'Ir1' => {
                                        'constant' => '',
                                        'ran' => ''
                                      }
                           }
           },
    'g4i5' => {
              'var_info' => {
                              'Ir1' => {
                                         'constant' => [
                                                         5
                                                       ],
                                         'ran' => ''
                                       },
                              'Uc1' => {
                                         'ran' => '',
                                         'constant' => [
                                                         5
                                                       ]
                                       }
                            },
              'ran' => ''
            },
    'h1i14' => {
             'var_info' => {
                             'Uc2' => {
                                        'constant' => '',
                                        'ran' => ''
                                      },
                             'Ir3' => {
                                        'constant' => '',
                                        'ran' => ''
                                      }
                           },
             'ran' => {
                        '0' => {
                                 'init' => 1,
                                 'end' => 4,
                                 'vars' => [
                                             'Uc2',
                                             'Ir3'
                                           ]
                               }
                      }
           },
    'h2i14' => {
             'ran' => {
                        '0' => {
                                 'vars' => [
                                             'Il'
                                           ],
                                 'end' => 4,
                                 'init' => 1
                               }
                      },
             'var_info' => {
                             'Il' => {
                                       'ran' => {
                                                  '1' => {
                                                           'end' => 5,
                                                           'init' => 2
                                                         }
                                                },
                                       'constant' => ''
                                     }
                           }
           },
    'k2' => {
            'var_info' => {
                            'Vr' => {
                                      'ran' => '',
                                      'constant' => ''
                                    }
                          },
            'ran' => ''
          },
    'k1' => {
            'var_info' => {
                            'Ir' => {
                                      'ran' => '',
                                      'constant' => ''
                                    },
                            'Vr' => {
                                      'ran' => '',
                                      'constant' => ''
                                    }
                          },
            'ran' => ''
          },
};

&main();

sub main {

    test_rlcc2();

}

sub test_rlcc2 {
    my $result = causalize($data_rlcc2_original);#return;
# warn "result: " . Dumper($result);
    my $expected =  {
          'ordered_graph' => [
                               'Uc15,g4i5 -> Ir15,Ir35,Ua5,g1i5,g2i5,g3i5',
                               'Uc25,f2 -> Ir,k1',
                               'Uc25,f2 -> Ir15,Ir35,Ua5,g1i5,g2i5,g3i5',
                               'Ir,k1 -> Vr,k2'
                             ],
          'all_macro_node' => [
                                [
                                  'Ir15',
                                  'Ir35',
                                  'Ua5',
                                  'g1i5',
                                  'g2i5',
                                  'g3i5'
                                ],
                                [
                                  'Uc15',
                                  'g4i5'
                                ],
                                [
                                  'Uc25',
                                  'f2'
                                ],
                                [
                                  'Uc11to4',
                                  'g4i14'
                                ],
                                [
                                  'Ir',
                                  'k1'
                                ],
                                [
                                  'Il1',
                                  'f1'
                                ],
                                [
                                  'Il2to5',
                                  'h2i14'
                                ],
                                [
                                  'Vr',
                                  'k2'
                                ],
                                [
                                  'Uc21to4',
                                  'h1i14'
                                ],
                                [
                                  'Ir11to4',
                                  'Ir31to4',
                                  'Ua1to4',
                                  'g1i14',
                                  'g2i14',
                                  'g3i14'
                                ]
                              ],
          'internal_macro_node_ordered' => [
                                             {
                                               'equations' => [
                                                                'g1i5',
                                                                'g2i5',
                                                                'g3i5'
                                                              ],
                                               'name' => 'Ir15,Ir35,Ua5,g1i5,g2i5,g3i5',
                                               'var_info' => {
                                                               'Ir1' => [
                                                                          5
                                                                        ],
                                                               'Ir3' => [
                                                                          5
                                                                        ],
                                                               'Ua' => [
                                                                         5
                                                                       ]
                                                             },
                                               'index' => '',
                                               'ran' => ''
                                             },
                                             {
                                               'ran' => '',
                                               'equations' => [
                                                                'g4i5'
                                                              ],
                                               'var_info' => {
                                                               'Uc1' => [
                                                                          5
                                                                        ]
                                                             },
                                               'index' => '',
                                               'name' => 'Uc15,g4i5'
                                             },
                                             {
                                               'ran' => '',
                                               'index' => '',
                                               'var_info' => {
                                                               'Uc2' => [
                                                                          5
                                                                        ]
                                                             },
                                               'name' => 'Uc25,f2',
                                               'equations' => [
                                                                'f2'
                                                              ]
                                             },
                                             {
                                               'name' => 'Uc11to4,g4i14',
                                               'index' => {
                                                            'Uc1' => 0
                                                          },
                                               'var_info' => {
                                                               'Uc1' => ''
                                                             },
                                               'equations' => [
                                                                'g4i14'
                                                              ],
                                               'ran' => {
                                                          'end' => 4,
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'Uc1'
                                                                    ],
                                                          'init' => 1
                                                        }
                                             },
                                             {
                                               'ran' => '',
                                               'name' => 'Ir,k1',
                                               'var_info' => {
                                                               'Ir' => []
                                                             },
                                               'index' => '',
                                               'equations' => [
                                                                'k1'
                                                              ]
                                             },
                                             {
                                               'ran' => '',
                                               'equations' => [
                                                                'f1'
                                                              ],
                                               'name' => 'Il1,f1',
                                               'var_info' => {
                                                               'Il' => [
                                                                         1
                                                                       ]
                                                             },
                                               'index' => ''
                                             },
                                             {
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'Il'
                                                                    ],
                                                          'init' => 1,
                                                          'end' => 4
                                                        },
                                               'index' => {
                                                            'Il' => 1
                                                          },
                                               'var_info' => {
                                                               'Il' => ''
                                                             },
                                               'name' => 'Il2to5,h2i14',
                                               'equations' => [
                                                                'h2i14'
                                                              ]
                                             },
                                             {
                                               'ran' => '',
                                               'equations' => [
                                                                'k2'
                                                              ],
                                               'name' => 'Vr,k2',
                                               'var_info' => {
                                                               'Vr' => []
                                                             },
                                               'index' => ''
                                             },
                                             {
                                               'ran' => {
                                                          'init' => 1,
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'Uc2'
                                                                    ],
                                                          'end' => 4
                                                        },
                                               'equations' => [
                                                                'h1i14'
                                                              ],
                                               'index' => {
                                                            'Uc2' => 0
                                                          },
                                               'var_info' => {
                                                               'Uc2' => ''
                                                             },
                                               'name' => 'Uc21to4,h1i14'
                                             },
                                             {
                                               'ran' => {
                                                          'next' => 1,
                                                          'vars' => [
                                                                      'Ir1',
                                                                      'Ir3',
                                                                      'Ua'
                                                                    ],
                                                          'init' => 1,
                                                          'end' => 4
                                                        },
                                               'equations' => [
                                                                'g1i14',
                                                                'g2i14',
                                                                'g3i14'
                                                              ],
                                               'name' => 'Ir11to4,Ir31to4,Ua1to4,g1i14,g2i14,g3i14',
                                               'var_info' => {
                                                               'Ua' => '',
                                                               'Ir3' => '',
                                                               'Ir1' => ''
                                                             },
                                               'index' => {
                                                            'Ua' => 0,
                                                            'Ir3' => 0,
                                                            'Ir1' => 0
                                                          }
                                             }
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

        my $match_mn = 0;
        foreach my $s_mn (@${second_mn}) {
            my $s_mn_name = $s_mn->{name};#warn "f_mn_name:$f_mn_name s_mn_name:$s_mn_name\n";
            if ($f_mn_name eq $s_mn_name ) {
                $match_mn = 1;

                my $s_mn_eq = $s_mn->{equations};
                # warn "f_mn_name:$f_mn_name s_mn_name:$s_mn_name\n";
                my $s_mn_var_info = $s_mn->{var_info};
                my $s_mn_ran = $s_mn->{ran};
                my $s_mn_index = $s_mn->{index};

                # check equations
                # warn "check equations \n";
                if(compare_arrays($f_mn_eq,$s_mn_eq,1) == 0) {
                    warn "compare_arrays return 0";
                    return 0;
                }

                # check var_info
                # warn "check var_info \n";
                if(compare_hash($f_mn_var_info,$s_mn_var_info) == 0) {
                    warn "compare_hash var_info return 0";
                    return 0;
                }

                # check ran
                # warn "check ran \n";
                if(compare_hash($f_mn_ran,$s_mn_ran) == 0) {
                    warn "compare_hash ran return 0";
                    return 0;
                }

                # check index
                # warn "check index \n";
                if(compare_hash($f_mn_index,$s_mn_index) == 0) {
                    warn "compare_hash index return 0";
                    return 0;
                }           
            }
            # return 1;
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

    # warn "\nar1: " .Dumper($ar1);
    # warn "\nar2: " .Dumper($ar2);

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
                    warn "11:" . Dumper($hash1->{$clave1}) . " ne " . Dumper($hash2->{$clave1}) . "\n";
                    return 0;
                }
                # print "Misma clave [$clave1], pero distinto valor: " . Dumper($hash1->{$clave1}) . " != " . Dumper($hash2->{$clave1}) . "\n";
                # return 0;
            }
            elsif (ref($hash1->{$clave1}) eq 'HASH') {
                if(compare_hash($hash1->{$clave1},$hash2->{$clave1})){
                    next;
                }
                else {
                    warn "HASH compare_hash\n";
                    warn "22:" . Dumper($hash1->{$clave1}) . " ne " . Dumper($hash2->{$clave1}) . "\n";
                    return 0;
                }
               # warn "HASH compare_hash\n";
               # return 0; 
            }
            elsif($hash1->{$clave1} ne $hash2->{$clave1}) {
                warn "33:" . Dumper($hash1->{$clave1}) . " ne " . Dumper($hash2->{$clave1}) . "\n";
                return 0;
            }
        }
    }

    # ok $hash1 is igual to $hash2
    return 1;
}

1;