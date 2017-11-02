package ProcessInternalMacroNodes;

use strict;
use warnings;
use Data::Dumper;
use Graph::Undirected;
use constant N => 100;
use lib '/Users/emanuel/Documents/personal/facultad/causalize/';
use Array::Utils qw(:all);
use Scalar::Util 'looks_like_number'; 
use Params::Validate qw(:all);
use constant DEBUG_PIMN => 0;

=item resolve_internal_macro_node

tomo un macro_node que es el que voy a resolver internamente, adicionalmente necesito: 
  - init_data que hace referencia a los datos originales
  - graph que es el grafo creado a partir de init_data en donde tengo los nodos formados
 por ecuaciones y variables(estas representan a un determinado indice, en caso de que corresponda), 
 tambien tiene informacion adicional del grafo, nos indica que indice debe usar cada variable.
  - all_macro_node esta formada por todos los macronodos, los necesitos para el orden interno del mn que estoy procesando
=cut
sub new {
    my $class = shift;
    my %args = @_;

    my $self = {
        init_data      => undef,
        graph          => undef,
        all_macro_node => undef,
        @_
    };

    bless $self, $class;
    
    my (@all_equations,@all_variables);
    my @vertices = $self->{graph}->vertices;

    foreach my $node (@vertices) {
        my $type = $self->{graph}->get_vertex_attribute($node, 'type');
        if ($type eq 'EQ') {
            push @all_equations, $node;
        } elsif($type eq 'VAR') {
            push @all_variables, $node;
        } else {
            die "Error. Node: $node type: $type";
        }

        my $index_var = $self->{graph}->get_vertex_attribute($node, 'index_var');
        if(defined $index_var) {
            my $original_var = $self->{graph}->get_vertex_attribute($node, 'original_var');
            $self->{graph_info}->{index}->{$original_var} = $index_var;
        }
    }

    $self->{all_equations} = \@all_equations;
    $self->{all_variables} = \@all_variables;

    return $self;
}

sub resolve_internal_macro_node {
    my $class = shift;

    my %args = validate(
        @_,
        {
            macro_node     => 1,
        }
    );

    my $macro_node = $args{macro_node};
    my $init_data = $class->{init_data};
    my $graph = $class->{graph};
    my $graph_info = $class->{graph_info};
    my $all_macro_node = $class->{all_macro_node};

    my $result;

    my @equations = intersect(@{$class->{all_equations}}, @{$macro_node});
    my @variables = intersect(@{$class->{all_variables}}, @{$macro_node});

    return unless(@equations);

    my $origin_vars = {};# tiene como key la variable original y como valor las constantes que puedan haber
    foreach my $e (@equations) {
        foreach my $v (@variables) {
            my $o_var = $graph->get_vertex_attribute($v, 'original_var');
            # en este caso puedo tener que $origin_vars tiene a=>[1,2] y me viene
            # como $init_data->{$e}->{var_info}->{$o_var}->{constant} [1,3,4] 
            # solo debo agregar 3 y 4
            if (keys %{$origin_vars} && $origin_vars->{$o_var}) {

                next unless ($init_data->{$e}->{var_info}->{$o_var} && @{$init_data->{$e}->{var_info}->{$o_var}->{constant}});# sino tengo constantes sigo
                my @new_constants = @{$init_data->{$e}->{var_info}->{$o_var}->{constant}};

                # recorro las nuevas constantes y me fijo si existe en origin_vars->{$o_vars}
                foreach my $nc (@new_constants) {
                    my @origin_constants = @{$origin_vars->{$o_var}};

                    my $exist = 0;
                    foreach my $c (@origin_constants) {
                        if($nc eq $c) {
                            $exist = 1;
                            last;
                        }
                    }
                    
                    # sino agregue antes la constante, la agrego ahora
                    unless($exist) {
                        # antes de agregarla debo fijarme que esta constante sea parte del macronodo
                        foreach my $var_mn (@variables) {
                            my $c_var = "$v$nc";
                            if ($var_mn eq $c_var) {
                                push @{$origin_vars->{$o_var}}, $nc;
                                last;
                            }
                        }
                    }
                }

            }
            else {
                # antes de agregar las constantes debo ver si c/u esta dentro del macronodo;
                if($init_data->{$e}->{var_info}->{$o_var} && @{$init_data->{$e}->{var_info}->{$o_var}->{constant}}) {

                    my @new_constants = @{$init_data->{$e}->{var_info}->{$o_var}->{constant}};
                    foreach my $nc (@new_constants) {

                        foreach my $var_mn (@variables) {
                            my $c_var = "$v$nc";
                            if ($var_mn eq $c_var) {
                                push @{$origin_vars->{$o_var}}, $nc;
                                last;
                            }
                        }

                    }

                }
                else {
                    $origin_vars->{$o_var} = [];
                }
            }
        }
    }

    my $ordered_ran;

    my $ordered_var_info = {};
    # tomo cualquier ecuacion y me fijo si estan dentro de un loop
    # si una esta en un loop el resto tmb lo esta
    # en este caso tomo la 1er ecuacion para chequear
    if (keys %{$init_data->{$equations[0]}->{ran}}) {
        my $init;
        my $end;
        my $next;
        my $val_index = 0;
        foreach my $e (@equations) {

            foreach my $v (@variables) {

                my $original_var = $graph->get_vertex_attribute($v, 'original_var');

                my $ran_diff_index = {};

                if (defined $init_data->{$e}->{var_info}->{$original_var}) {
                    $ran_diff_index = $init_data->{$e}->{var_info}->{$original_var}->{ran};
                }

                my $ran_eq = $init_data->{$e}->{ran}->{0};
                
                # si existe ran_diff_index signigica que la variable tiene indices distintos al del rango de la ecuacion
                if (keys %{$ran_diff_index}) {

                    # chequeo que los valores del rango sean o todos positivos o todos negativos
                    foreach my $index (keys %{$ran_diff_index}) {

                        if ($val_index > 0) {
                            die "Index < and > in the same equation" if ($index < 0);

                        } 
                        elsif ($val_index < 0) {
                            die "Index < and > in the same equation" if ($index > 0);
                        } 
                        else {
                            $val_index = $index;
                        }

                    }

                    my $init_ran_eq = $ran_eq->{init};
                    my $end_ran_eq = $ran_eq->{end};
                    looks_like_number($init_ran_eq);
                    looks_like_number($end_ran_eq);

                    my $ordered = { inc => 0, dec => 0 };
                    foreach my $other_var_index (keys %{$ran_diff_index}) {

                        # ahora tengo que analizar los demas indices de la variable dentro de la ecuacion
                        # buscando en los otros macro nodos para ver el orden interno de este loop

                        # este es el indice elegido para la variable cuando tiene mas de uno
                        my $index = $graph_info->{index}->{$original_var};

                        next if ($other_var_index eq $index);

                        my $init_var = $other_var_index + $init_ran_eq;
                        my $init_var_index = "$original_var$init_var";

                        my $end_var = $other_var_index + $end_ran_eq;
                        my $end_var_index = "$original_var$end_var";

                        # busco si el limite inferior debe resolver antes de otra variable
                        foreach my $other_mn (@{$all_macro_node}) {
                            next if ($macro_node eq $other_mn);

                            foreach my $node (@{$other_mn}) {
                                if($node eq $init_var_index){
                                    $init = $ran_eq->{init};
                                    $end  = $ran_eq->{end};
                                    $next = 1;
                                    if(!$ordered->{dec}) {
                                        $ordered->{inc} = 1; 
                                    }
                                    else {
                                        die "Loop already ordered: dec";
                                    }
                                }
                                elsif($node eq $end_var_index) {
                                    $init = $ran_eq->{end};
                                    $end  = $ran_eq->{init};
                                    $next = -1;
                                    if(!$ordered->{inc}) {
                                        $ordered->{dec} = 1; 
                                    }
                                    else {
                                        die "Loop already ordered: inc";
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        my $vars = $init_data->{$equations[0]}->{ran}->{0}->{vars};
        my $init_default = $init_data->{$equations[0]}->{ran}->{0}->{init};
        my $end_default = $init_data->{$equations[0]}->{ran}->{0}->{end};
        my $next_default = 1;
        my @vars = sort(keys(%{$origin_vars}));

        $ordered_ran = {
            init => $init || $init_default,
            end  => $end  || $end_default,
            next => $next || $next_default,
            vars => \@vars
        };

        $ordered_var_info = $origin_vars;

    } 
    else {

        foreach my $e (@equations) {

            my @eq_variables = keys($init_data->{$e}->{var_info});
            foreach my $v (@variables) {
                

                my $original_var = $graph->get_vertex_attribute($v, 'original_var');
                die "The ran of var:$v moust be null" if ($init_data->{$e}->{var_info}->{$original_var} && keys %{$init_data->{$e}->{var_info}->{$original_var}->{ran}});

                my $is_var_in_m_n = 0;
                foreach my $v1 (@eq_variables) {
                    if($v1 eq $original_var) {
                        $is_var_in_m_n = 1;
                        last;
                    }
                }

                next unless($is_var_in_m_n);

                my $indices;
                if(defined $init_data->{$e}->{var_info}->{$original_var}) {
                    $indices = $init_data->{$e}->{var_info}->{$original_var}->{constant};
                }
                
                my @vars;
                $ordered_var_info->{$original_var} = [] unless($ordered_var_info->{$original_var});
                if ($indices) {
                    foreach my $ind (@{$indices}) {
                        push @{$ordered_var_info->{$original_var}}, $ind unless(grep {$_ eq $ind} @{$ordered_var_info->{$original_var}});
                    }
                }
            }
        }
        $ordered_ran = {};
    }

    my $ind={};

    foreach my $v (keys %{$ordered_var_info}) {
        $ind->{$v} = $graph_info->{index}->{$v};
    }

    my $index = {};
    $index = $ind if(keys %{$ordered_ran});

    my $ordered_graph = {
        equations  => \@equations,
        var_info   => $ordered_var_info,
        ran        => $ordered_ran,
        index      => $index
    };

    return $ordered_graph;

}

# my $causalized = {
#     ran        => {
#         init => N-1,
#         end  => 1,
#         next => 1,
#         vars => [a,b]
#     },
#     equations  => [fi,gi]
#     var_info  => {
#       a => '',
#       b => '',
#     }
# }


1;