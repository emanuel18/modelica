# N = 10
# a[N], b[N], c
# for i in 1:N-2 loop
#   a[i]-b[i]+c+a[N-1]=8;       //fi
#   a[i]+b[i]-a[i+1]-b[N-1]=5;  //gi
# end for;
#
# a[N-1]-b[N-1]=8;  //fn
# a[N-1]+b[N-1]=5;  //gn
#
# a[N] = 22             //h1
# a[N] + b[N] + c = 22  //h2
# c = 10                //h3
our $init_data4 = {
    fi => {
        ran => { 
            0 => {
                init => 1,
                end  => N-2,
                vars => ['a','b']
            }
        },
        var_info => {
            a => {
                ran      => "",
                constant => [N-1]
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
                constant => [N-1]
            }
        }, 
    },
    fn => {
        ran => "",# si el rango es vacio es que no estas dentro de un for
        var_info => {
            a => [ N-1 ],
            b => [ N-1 ]
        } 
    },
    gn => {
        ran => "",
        var_info => {
            a => [ N-1 ],
            b => [ N-1 ]
        } 
    },
    h1 => {
        ran => "",
        var_info => {
            a => [ N ],
        } 
    },
    h2 => {
        ran => "",
        var_info => {
            a => [ N ],
            b => [ N ],
            c => ""
        } 
    },
    h3 => {
        ran => "",
        var_info => {
            c => ""
        } 
    },
};


los rangos de un for los representod de la siguiente forma, 
si solamente tengo 0 significa que solo tengo i, en vars tiene
las variables que estan afectadas en el for
si tengo 1, es i+1 
si tengo -1 es i-1
        ran => { 
            0 => {
                init => 1,
                end  => N-2,
                vars => ['a','b']
            }
        },

si la ecuacion no tiene rango es que no esta dentro de un for 

los ran estan presentes como atributos de las variables, dentro de var_info 
si estan vacias significa que las variables
tiene el ran del for, caso contrario se le agrega el ran a la variables, por ejemplo si la ecuacion
es a[i]-a[i+1] con i de 1 a N
ran   => {
    0 => {
        init => 1,
        end  => N,
    },
    1 => {
        init => 2,
        end  => N+1,
    }
},

La unica diferencia entre ran de ecuacion y variable es que en las ecuaciones tengo el atributo vars
que me dicen cuales son las variables afectadas por el for

otro atributo que tiene la variable es "constant" que representa algun valor constante que puede asumir 
esa variable dentro de la ecuacion por ejemplo a[i]-a[i+1]-a[5]+a[6]
            a => {
                ran   => {
                    0 => {
                        init => 1,
                        end  => N,
                    },
                    1 => {
                        init => 2,
                        end  => N-1,
                    }
                },
                constant => [5,6]
            },


para el caso de las ecuaciones que no esta dentro de un for el ran es vacio y las variables tienen directamente
los valores que asumen


yo proceso lo ante
