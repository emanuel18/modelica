use strict;
use warnings;
use Data::Dumper;

use constant DEBUG => 0;
use constant N => 10;

use Params::Validate qw(:all);
use Exporter qw(import);
our @EXPORT_OK = qw( get_vars_solved_in_other_mn );
our %EXPORT_TAGS = (
    'all' => \@EXPORT_OK,
);

# tengo todos los macro nodos por un lado y los datos iniciales por otro
# voy procesando los macronodos de a uno y para c/u de las ecuaciones, busco todas las variables correspondiente a dicha ecuacion en los 
# datos originales y voy comparando si dichas ecuaciones(con sus respectivos rangos) estan dentro 
# del macronodo, si no lo esta significa que dicha variable debe resolverse en otro macronodo
sub get_vars_solved_in_other_mn {
    my %args = validate(
        @_,
        {
            init_data           => 1,
            internal_macro_node => 1,
        }
    );

    my $init_data = $args{init_data};

    foreach my $mn (@{$args{internal_macro_node}}) {

        # ecuaciones del macronodo
        foreach my $eq (@{$mn->{equations}}) {

            # esta dentro de un loop
            if($init_data->{$eq}->{ran}) {

                # miro cada una de las variables
                foreach my $var (keys %{$init_data->{$eq}->{var_info}}) {

                    my @vars_in_ran = @{$init_data->{$eq}->{ran}->{0}->{vars}};
                    my $var_is_in_ran = 0;

                    # me fijo si la variable es parte del ran, es decir que depende del indice
                    foreach my $v (@vars_in_ran) {
                        if($v eq $var) {
                            $var_is_in_ran = 1;
                            last;
                        }
                    }

                    # si la variable no es parte del ran significa que es una constante como a[1] que es parte de un array
                    # o es una constante c
                    unless($var_is_in_ran) {
                        # si la variable no es parte del rango de la ecuacion debe tener su ran vacio
                        die "The ran of the var:$var must be null" if($init_data->{$eq}->{var_info}->{$var}->{ran});

                        unless(defined $mn->{var_info}->{$var}) {
                            $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran} = '';
                            $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant} = $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant} || '';
                            next;
                        }
                    }
 
                    my $var_ran = $init_data->{$eq}->{var_info}->{$var}->{ran};
                    $var_ran = $init_data->{$eq}->{ran} unless($var_ran);

                    # si la variable no esta como indice en el macro nodo significa 
                    # que dicha variable debe ser completamente resuelta en otro mn
                    unless(defined $mn->{index}->{$var}) {
                        $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran} = $var_ran;
                        $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant} = '' unless(defined $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant});
                        next;
                    }
  
                    # recorro los indices de la variables original a ver cual indice NO esta
                    # incluido en el macronodo
                    if ($var_ran) {

                        my @index = keys %{$var_ran};
                    
                        foreach my $i (@index) {

                            # el indice del macronodo no es el mismo que el indice de
                            # la variable
                            if($i != $mn->{index}->{$var}) {
                                # si es 0 tiene el rango de la ecuacion
                                if ($i == 0) {
                                    $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran} = $init_data->{$eq}->{ran};
                                    $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant} = '' unless(defined $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant});
                                } 
                                else {
                                    $mn->{var_solved_in_other_mn}->{$eq}->{$var} = {
                                      ran => {
                                        $i => $init_data->{$eq}->{var_info}->{$var}->{ran}->{$i},
                                      },
                                      constant => ""
                                    };
                                }
                            }
                        }
                    }
                    # ahora chequeo las constantes que estan dentro de la ecuacion del loop
                    if ($init_data->{$eq}->{var_info}->{$var}->{constant}) {
                        my @constant = @{$init_data->{$eq}->{var_info}->{$var}->{constant}};

                        if(@constant) {

                            foreach my $c_init_data (@constant) {

                                my $exist = 0;

                                if($mn->{var_info}->{$var}) {
                                    my @constant_internal_mn = @{$mn->{var_info}->{$var}};
                                    foreach my $c_internal_mn (@constant_internal_mn) {
                                        if($c_init_data eq $c_internal_mn) {
                                            $exist = 1;
                                            last;
                                        }
                                    }
                                }

                                if($exist == 0) {
                                    push @{$mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant}}, $c_init_data;
                                    $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran} = '' unless(defined $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran});
                                }
                            }
                        }
                    }
                }
            }
            # estas son las ecuaciones que no estan dentro de un loop
            else {
                foreach my $var (keys %{$init_data->{$eq}->{var_info}}) { 
  
                    die "The ran of eq:$eq var:$var moust be null" if ($init_data->{$eq}->{var_info}->{$var}->{ran});

                    # son constantes que pertenecen a un arreglo, a[1], a[2]
                    if ($init_data->{$eq}->{var_info}->{$var}->{constant}) {
                        my @constant = @{$init_data->{$eq}->{var_info}->{$var}->{constant}};

                        if(@constant) {

                            foreach my $c_init_data (@constant) {

                                my $exist = 0;
                                if($mn->{var_info}->{$var}) {
                                    my @constant_internal_mn = @{$mn->{var_info}->{$var}};

                                    foreach my $c_internal_mn (@constant_internal_mn) {
                                      
                                        if($c_init_data eq $c_internal_mn) {
                                            $exist = 1;
                                            last;
                                        }
                                    }
                                }

                                if($exist == 0) {
                                    push @{$mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant}}, $c_init_data;
                                    $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran} = '' unless(defined $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran});
                                }
                            }
                        }
                    }
                    # es una constante que no pertenece a un arreglo: c,d
                    else {
                        my @vars_internal_mn = keys %{$mn->{var_info}};
                        my $exist = 0;
                        foreach my $v (@vars_internal_mn) {
                            # descarto las variables del mn que no son constantes
                            next if (@{$mn->{var_info}->{$v}});
                            if($var eq $v){
                                $exist = 1;
                                last;
                            }
                        }
                        if($exist == 0) {
                            $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{constant} = '';
                            $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran} = '' unless(defined $mn->{var_solved_in_other_mn}->{$eq}->{$var}->{ran});
                        }
                    }
                }
            }
        }
    }
}

1;
