use strict;
use warnings;
use Data::Dumper;
use Graph::Undirected;
use constant N => 10;
use constant PATH_DOT => "/Users/emanuel/Documents/personal/facultad/causalize/bg.dot";
use constant PATH_PNG => "/Users/emanuel/Documents/personal/facultad/causalize/bg.png";
use Scalar::Util 'looks_like_number';  
use Exporter qw(import);
our @EXPORT_OK = qw(build_graph build_png );
use constant DEBUG => 0;
use constant DEBUG1 => 0;

use Params::Validate qw(:all);


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
# c = 10    

# our $init_data4 = {
#     fi => {
#         ran => { 
#             0 => {
#                 init => 1,
#                 end  => N-2,
#                 vars => ['a','b']
#             }
#         },
#         var_info => {
#             a => {
#                 ran      => "",
#                 constant => [N-1]
#             },
#             b => {
#                 ran      => "",
#                 constant => ""
#             },
#             c => {
#                 ran      => "",
#                 constant => ""
#             },
#         }, 
#     },
#     gi => {
#         ran => {
#             0 => {
#                 init => 1,
#                 end  => N-2,
#                 vars => ['a','b']
#             }
#         },
#         var_info => {
#             a => {
#                 ran   => {
#                     0 => {
#                         init => 1,
#                         end  => N-2,
#                     },
#                     1 => {
#                         init => 2,
#                         end  => N-1,
#                     }
#                 },
#                 constant => ""
#             },
#             b => {
#                 ran      => "",
#                 constant => [N-1]
#             }
#         }, 
#     },
#     fn => {
#         ran => "",# si el rango es vacio es que no estas dentro de un for
#         var_info => {
#             a => {
#                 ran      => "",
#                 constant => [N-1]
#             },
#             b => {
#                 ran      => "",
#                 constant => [N-1]
#             },
#         }, 
#     },
#     gn => {
#         ran => "",
#         var_info => {
#             a => {
#                 ran      => "",
#                 constant => [N-1]
#             },
#             b => {
#                 ran      => "",
#                 constant => [N-1]
#             },
#         }, 
#     },
#     h1 => {
#         ran => "",
#         var_info => {
#             a => {
#                 ran      => "",
#                 constant => [N]
#             }
#         }, 
#     },
#     h2 => {
#         ran => "",
#         var_info => {
#             a => {
#                 ran      => "",
#                 constant => [N]
#             },
#             b => {
#                 ran      => "",
#                 constant => [N]
#             },
#             c => {
#                 ran      => "",
#                 constant => ""
#             },
#         }, 
#     },
#     h3 => {
#         ran => "",
#         var_info => {
#             c => {
#                 ran      => "",
#                 constant => ""
#             }
#         }
#     },
# };

# &main();

# sub main {

    # my $data = build_graph($init_data4);

    # my $graph = Graph::Undirected->new();

    # build_png($graph);
# }

sub build_graph {
    my %args = validate(
        @_,
        {
            init_data    => 1,
        }
    );

    my $graph = Graph::Undirected->new();

    my $init_data = $args{init_data};

    my %graph_info;

    _build_graph_without_for($init_data,$graph);
    _build_graph_with_for($init_data,$graph,\%graph_info);

    my $data = {
        graph       => $graph,
        graph_info  => \%graph_info
    };

    # armo el png del grafo
    build_png($graph);

    return $data;
}

# este es el caso cuando el rango del for es vacio
sub _build_graph_without_for {
    my $init_data = shift;
    my $graph = shift;

    foreach my $eq (keys %{$init_data}) {
        next if($init_data->{$eq}->{ran} ne '');

        $graph->add_vertex( $eq );
        print "\t \$graph->add_vertex( \'$eq\' );\n" if DEBUG1;

        print "\n\n_build_graph_without_loop EQ: $eq \n" if DEBUG;

        $graph->set_vertex_attribute($eq, 'type', 'EQ');
        print "\t \$graph->set_vertex_attribute(\'$eq\', \'type\', \'EQ\');\n" if DEBUG1;

        my $var_info = $init_data->{$eq}->{var_info};

        foreach my $var (keys %{$var_info}) {

            my $var_data = $init_data->{$eq}->{var_info}->{$var}->{constant};

            if ( @$var_data ) {
                foreach my $index (@{$var_data}) {

                    if ($index) {
                        looks_like_number($index);

                        my $new_var = $var . $index;

                        $graph->add_vertex( $new_var );
                        print "\t \$graph->add_vertex( \'$new_var\' );\n" if DEBUG1;

                        $graph->set_vertex_attribute($new_var, 'type', 'VAR');
                        $graph->set_vertex_attribute($new_var, 'original_var', $var);

                        print "\t \$graph->set_vertex_attribute(\'$new_var\', \'type\', \'VAR\');\n" if DEBUG1;
                        print "\t \$graph->set_vertex_attribute(\'$new_var\', \'original_var\', \'$var\');\n" if DEBUG1;

                        print "\t1without_loop var: $new_var\n" if DEBUG;
                        print "\t1without_loop add_edge: ($eq, $new_var)\n" if DEBUG;

                        $graph->add_edge( $eq, $new_var );
                        print "\t \$graph->add_edge( \'$eq\', \'$new_var\' );\n" if DEBUG1;
                    } else {
                        # caso de una variable como c[N]
                        my $new_var = $var;

                        print "\t2without_loop var: $new_var\n" if DEBUG;
                        print "\t2without_loop add_edge: ($eq, $new_var)\n" if DEBUG;

                        $graph->add_vertex( $new_var );

                        print "\t \$graph->add_vertex( \'$new_var\' );\n" if DEBUG1;

                        $graph->set_vertex_attribute($new_var, 'type', 'VAR');
                        $graph->set_vertex_attribute($new_var, 'original_var', $var);

                        print "\t \$graph->set_vertex_attribute(\'$new_var\', \'type\', \'VAR\');\n" if DEBUG1;
                        print "\t \$graph->set_vertex_attribute(\'$new_var\', \'original_var\', \'$var\');\n" if DEBUG1;

                        $graph->add_edge( $eq, $new_var );
                        print "\t \$graph->add_edge( \'$eq\', \'$new_var\' );\n" if DEBUG1;
                    }
                }
            }
            else { # este es el caso de c
                my $new_var = $var;print "salgo por c";

                $graph->add_vertex( $new_var );
                $graph->set_vertex_attribute($new_var, 'type', 'VAR');
                $graph->set_vertex_attribute($new_var, 'original_var', $var);
                print "\t3without_loop var: $new_var\n" if DEBUG;
                print "\t3without_loop add_edge: ($eq, $new_var)\n" if DEBUG;
                $graph->add_edge( $eq, $new_var );

                print "\t \$graph->add_vertex( \'$new_var\' );\n" if DEBUG1;
                print "\t \$graph->add_edge( \'$eq\', \'$new_var\' );\n" if DEBUG1;
                print "\t \$graph->set_vertex_attribute(\'$new_var\', \'type\', \'VAR\');\n" if DEBUG1;
                print "\t \$graph->set_vertex_attribute(\'$new_var\', \'original_var\', \'$var\');\n" if DEBUG1;
            }
        }

    }
}


sub _build_graph_with_for {
    my $init_data = shift;
    my $graph = shift;
    my $graph_info = shift;

    my $get_var_index = {};
    my @vertices_to_delete;
    foreach my $eq (keys %{$init_data}) {
        next if($init_data->{$eq}->{ran} eq '');

        if ($graph->has_vertex($eq)) {
            die "The vertex eq $eq is already in the graph";
        }
        $graph->add_vertex( $eq );
        print "\t \$graph->add_vertex( \'$eq\' );\n" if DEBUG1;

        $graph->set_vertex_attribute($eq, 'type', 'EQ');
        print "\t \$graph->set_vertex_attribute(\'$eq\', \'type\', \'EQ\');\n" if DEBUG1;

        print "\n\n_build_graph_with_loop EQQQ: $eq \n" if DEBUG;  

        my $var_info = $init_data->{$eq}->{var_info};

        foreach my $var (keys %{$var_info}) {
            print "\t_build_graph_with_loop VARR: $var \n" if DEBUG;

            # este es el caso cuando esta dentro del for, tengo que ver si tiene el indice

            # aca tengo que ver que indice debo dejar para el grafo, este indice debe ser tal que los valores que asumen 
            # las variables dentro del for no pertenezca a un macronodo externo, es decir, los valores asumidos por las 
            # variables deben resolverse en ese lazo y no fuera.

            my $ran = $init_data->{$eq}->{ran}->{0};
            my $init_eq = $ran->{init};
            my $end_eq  = $ran->{end};
            looks_like_number($init_eq);
            looks_like_number($end_eq);

            my $new_var = $var;

            my $vars_ran = $ran->{vars};
            my $is_in_ran = 0;
            # me fijo si dentro de vars de ran esta la variable que estoy analizando 
            # de var_info
            foreach my $v (@{$vars_ran}) {
                if ($v eq $var) {
                    $is_in_ran = 1;
                    last;
                }
            }

            next unless ( $is_in_ran );
            # recorro los indices de la variable para ver cual indice debo usar
            # el resto de los indices son descartados lo cual significa que 
            # las variables con esos indices se resuelven en otro macro nodo
            my $var_ran = $var_info->{$var}->{ran} || $init_data->{$eq}->{ran};

            $graph_info->{index}->{$var} = 0 unless($var_ran);

            # en este foreach busco si hay algun indice que los dos extremos no esten en otro vertice
            my $has_index = 0;
            foreach my $var_index (keys %{$var_ran}) {
                looks_like_number($var_index);
                my $init = $init_eq + $var_index;
                my $end  = $end_eq  + $var_index;
                my $has_init_vertex = $graph->has_vertex("$var$init") || 0;
                my $has_end_vertex = $graph->has_vertex("$var$end") || 0;

                if (!$has_init_vertex && !$has_end_vertex && !$has_index) {
                    $new_var .= $init;
                    $new_var .= "to$end" if ($init != $end); 

                    $graph->add_vertex( $new_var );

                    $graph_info->{index}->{$var} = $var_index;

                    $graph->set_vertex_attribute($new_var, 'type', 'VAR');
                    $graph->set_vertex_attribute($new_var, 'original_var', $var);

                    print "\t1with_loop var: $new_var\n" if DEBUG;
                    print "\t1with_loop add_edge: ($eq, $new_var)\n" if DEBUG;

                    print "\t \$graph->add_vertex( \'$new_var\' );\n" if DEBUG1;
                    print "\t \$graph->add_edge( \'$eq\', \'$new_var\' );\n" if DEBUG1;
                    print "\t \$graph->set_vertex_attribute(\'$new_var\', \'type\', \'VAR\');\n" if DEBUG1;
                    print "\t \$graph->set_vertex_attribute(\'$new_var\', \'original_var\', \'$var\');\n" if DEBUG1;

                    $graph->add_edge( $eq, $new_var );
                    $has_index = 1;
                }
            }

            unless($has_index) {
                foreach my $var_index (keys %{$var_ran}) {

                    looks_like_number($var_index);
                    my $init = $init_eq + $var_index;
                    my $end  = $end_eq  + $var_index;
                    my $has_init_vertex = $graph->has_vertex("$var$init") || 0;
                    my $has_end_vertex = $graph->has_vertex("$var$end") || 0;

                    if (!$has_init_vertex && !$has_end_vertex && !$has_index) {

                        my $init_var_in_cycle = 0;
                        my $graph_tmp = $graph->copy_graph;
                        while (my @cycle = $graph_tmp->find_a_cycle) {

                            foreach my $node (@cycle) {
                                if($node eq "$var$init") {
                                    $init_var_in_cycle = 1;
                                    last;
                                }
                                last if($init_var_in_cycle);
                                
                            }
                            $graph_tmp = $graph_tmp->delete_cycle(@cycle);
                        }

                        if(!$init_var_in_cycle) {

                            $new_var .= $init;
                            $new_var .= "to$end" if ($init != $end); 

                            $graph_info->{index}->{$var} = $var_index;

                            $graph->set_vertex_attribute($new_var, 'type', 'VAR');
                            $graph->set_vertex_attribute($new_var, 'original_var', $var);

                            print "\t \$graph->set_vertex_attribute(\'$new_var\', \'type\', \'VAR\');\n" if DEBUG1;
                            print "\t \$graph->set_vertex_attribute(\'$new_var\', \'original_var\', \'$var\');\n" if DEBUG1;


                            $graph->add_vertex( $new_var );
                            print "\t1aa with_loop var: $new_var\n" if DEBUG;
                            print "\t1aa with_loop add_edge: ($eq, $new_var)\n" if DEBUG;

                            print "\t \$graph->add_vertex( \'$new_var\' );\n" if DEBUG1;
                            print "\t \$graph->add_edge( \'$eq\', \'$new_var\' );\n" if DEBUG1;

                            $graph->add_edge( $eq, $new_var );
                            $has_index = 1;

                            # ahora debo remover el node $var$init ya que se resuelve aca
                            push @vertices_to_delete, "$var$init";
                        }
                    }

                    if (!$has_init_vertex && $has_end_vertex && !$has_index) {

                        my $init_var_in_cycle = 0;
                        my $graph_tmp = $graph->copy_graph;
                        while (my @cycle = $graph_tmp->find_a_cycle) {
                            foreach my $node (@cycle) {
                                if($node eq "$var$end") {
                                    $init_var_in_cycle = 1;
                                    last;
                                }
                                last if($init_var_in_cycle);
                            
                            }
                            $graph_tmp = $graph_tmp->delete_cycle(@cycle);
                        }

                        if(!$init_var_in_cycle) {

                            $new_var .= $init;
                            $new_var .= "to$end" if ($init != $end); 

                            $graph->add_vertex( $new_var );

                            $graph_info->{index}->{$var} = $var_index;

                            $graph->set_vertex_attribute($new_var, 'type', 'VAR');
                            $graph->set_vertex_attribute($new_var, 'original_var', $var);

                            print "\t \$graph->set_vertex_attribute(\'$new_var\', \'type\', \'VAR\');\n" if DEBUG1;
                            print "\t \$graph->set_vertex_attribute(\'$new_var\', \'original_var\', \'$var\');\n" if DEBUG1;


                            print "\t1bb with_loop var: $new_var\n" if DEBUG;
                            print "\t1bb with_loop add_edge: ($eq, $new_var)\n" if DEBUG;

                            print "\t \$graph->add_vertex( \'$new_var\' );\n" if DEBUG1;
                            print "\t \$graph->add_edge( \'$eq\', \'$new_var\' );\n" if DEBUG1;

                            $graph->add_edge( $eq, $new_var );
                            $has_index = 1;
                            push @vertices_to_delete, "$var$end";
                        }
                    }
                    next if($has_index);
                }
            }

            # ahora analizo las contantes que puede tener cada variable dentro del for
            my $constants = $var_info->{$var}->{constant};

            next unless($constants);

            foreach my $c (@{$constants}) {
                $new_var = $var . $c;

                $graph->add_vertex( $new_var );

                $graph->set_vertex_attribute($new_var, 'type', 'VAR');
                $graph->set_vertex_attribute($new_var, 'original_var', $var);    

                print "\t \$graph->set_vertex_attribute(\'$new_var\', \'type\', \'VAR\');\n" if DEBUG1;
                print "\t \$graph->set_vertex_attribute(\'$new_var\', \'original_var\', \'$var\');\n" if DEBUG1;


                print "\t2with_loop var: $new_var\n" if DEBUG;
                print "\t2with_loop add_edge: ($eq, $new_var)\n" if DEBUG;

                print "\t \$graph->add_vertex( \'$new_var\' );\n" if DEBUG1;
                print "\t \$graph->add_edge( \'$eq\', \'$new_var\' );\n" if DEBUG1;

                $graph->add_edge( $eq, $new_var );
            }
        }

    }

    $graph = $graph->delete_vertices(@vertices_to_delete);
}

sub build_png {
    my $graph = shift;

    my $g = "graph G{   
        subgraph cluster0{
        label = \"Ecuaciones\"; 
        edge [style=invis];
        ";


    my @all_nodes = $graph->vertices;
    my @ec;
    my @var;
    foreach my $node (@all_nodes) {

        die "Node:$node is not defined" unless($graph->get_vertex_attribute($node, 'type'));
        if ($graph->get_vertex_attribute($node, 'type') eq 'EQ') {
            push @ec, $node;
        } else {
            push @var, $node;
        }
    }

    my $ecs = join ' -- ', sort @ec;
    my $vars = join ' -- ', sort @var;

    $g .= $ecs . ";\n";
    $g .= "        }
        subgraph cluster1{
        label = \"Variables\";
        edge [style=invis];
        ";
    $g .= $vars . ";\n";


    $g .= "        }
        edge [constraint=false];\n";

    my @all_edges = $graph->edges;
    foreach my $e (@all_edges) {
        my @e = @$e;
        my $edge = "        " . $e[0] . " -- " . $e[1] . ";\n";
        $g .= $edge;
    }
    $g .= "}";


    open( my $output_file, '>:utf8', PATH_DOT) or die "Can't open";
    print $output_file $g;
    close $output_file;

    my $command = "dot -Tpng " . PATH_DOT . " -o " . PATH_PNG;

    my $output = `$command 2>&1`;
}

1;