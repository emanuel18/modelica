package BuildMacroNodes;

use strict;
use warnings;
use Data::Dumper;
use Graph::Undirected;
use Params::Validate qw(:all);

use Exporter qw(import);
our @EXPORT_OK = qw( build_macro_nodes );

our %EXPORT_TAGS = (
    'all' => \@EXPORT_OK,
);


# devuelve todos los macro nodos
# si estan dentro de un ciclo es un macronodo
# si se puede causalizar es un macronodo
sub build_macro_nodes {
    my %args = validate(
        @_,
        {
            graph      => 1,
        }
    );
    my $original_graph = $args{graph};
    my $graph = $original_graph->deep_copy_graph;

    my @macro_node = ();

    while (my @cycle_nodes = $graph->find_a_cycle) {

        @cycle_nodes = sort @cycle_nodes;

        my @mn_eq = ();
        my @mn_var = ();
        my @new_edge = ();# estos son las nuevas aristas que van desde el macronodo hasta vertices que no estan en el macronodo
        my $is_big_macro_node = 1; # este es el mayor macronodo
        foreach my $node (@cycle_nodes) {

            die "Node:$node is not defined type" unless($graph->get_vertex_attribute($node, 'type'));

            if($graph->get_vertex_attribute($node, 'type') eq 'EQ') {
                push @mn_eq, $node;
            }
            elsif($graph->get_vertex_attribute($node, 'type') eq 'VAR') {
                push @mn_var, $node;
            }
            else {
                die "Undefined type to node:$node";
            }
        
            # tengo que buscar si dentro del macrono hay algun nodo que tenga una arista
            # con otro nodo que no este dentro del ciclo

            my @successors = $graph->successors($node);
    
            if(@successors) {
                foreach my $s_node (@successors) {
                    my $is_in_this_mn = 0;
                    foreach my $n (@cycle_nodes) {
                        if($s_node eq $n) {
                            $is_in_this_mn = 1;
                            last;
                        }
                    }
                    if(!$is_in_this_mn) {
                        push @new_edge,$s_node;
                        $is_big_macro_node = 0;
                    }
                }
            }
        }

        # delete cycle
        $graph = $graph->delete_cycle(@cycle_nodes);
        # delete vertices
        $graph = $graph->delete_vertices(@cycle_nodes);
        if($is_big_macro_node) {

            $graph = $graph->delete_vertices(@cycle_nodes);

            @cycle_nodes = map {split("AND",$_)} @cycle_nodes;
            @cycle_nodes = sort(@cycle_nodes);
            push @macro_node, \@cycle_nodes;
        } 
        else {

            my $name_mn_eq = join("AND",@mn_eq);
            my $name_mn_var = join("AND",@mn_var);

            # added vertices
            $graph->add_vertices( $name_mn_eq, $name_mn_var );

            $graph->set_vertex_attribute($name_mn_eq, 'type', 'EQ');
            $graph->set_vertex_attribute($name_mn_var, 'type', 'VAR');

            # added new edge
            $graph->add_edge( $name_mn_eq, $name_mn_var );


            # agrego las nuevas aristas del macronodo
            foreach my $node (@new_edge) {
                if($graph->get_vertex_attribute($node, 'type') eq 'VAR') {
                    $graph->add_edge( $node, $name_mn_var );
                }
                elsif($graph->get_vertex_attribute($node, 'type') eq "EQ") {
                    $graph->add_edge( $node, $name_mn_eq );
                }
                else {
                    die "Undefined type to node:$node in new edge";
                }
            }
        }
    }

    # estos son los nodos que se puede causalizar
    my @vertices = $graph->vertices;

    while(@vertices) {

        foreach my $v (@vertices) {

            if ($graph->degree($v) && $graph->degree($v) == 1) {

                my @successors = $graph->successors($v);
                # como es de grado 1 el vertice solo tiene un sucesor
                my $v2 = shift(@successors);

                my @node = ($v,$v2);
                @node = sort(@node);

                @node = map {split("AND",$_)} @node;
                @node = sort(@node);

                push @macro_node, \@node;

                $graph = $graph->delete_edge($v,$v2);

                $graph = $graph->delete_vertices($v,$v2);
            }
        }

        @vertices = $graph->vertices;
    }

    return \@macro_node;
}

1;