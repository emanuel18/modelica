package Causalize;

use strict;
use warnings;
use Data::Dumper;
use Graph::Directed;

use lib "/Users/emanuel/Google Drive/personal/facultad/causalize";
use PreProcessData qw(:all);
use BuildGraph qw(:all);
use BuildMacroNodes qw(:all);
use ProcessInternalMacroNodes;
use VarSolvedInOtherMN qw(:all);
use SortMacroNodes qw(:all);
use Util qw(:all);
use Array::Utils qw(:all);
use Time::HiRes qw( gettimeofday tv_interval );

use constant DEBUG => 0;

use Exporter qw(import);
our @EXPORT_OK = qw( causalize );
our %EXPORT_TAGS = (
    'all' => \@EXPORT_OK,
);

sub causalize {
    my $init_data = shift;

    my $start_time = [ gettimeofday ];

    # hace un procesamiento previo buscando si los rangos de las
    # ecuaciones no conciden, si pasa esto modifica los datos iniciales
    # particionando los rangos

    check_and_transform_data($init_data);
    warn "Preprocess: " . Dumper($init_data) if (DEBUG);

    my $graph = build_graph(init_data => $init_data);
    warn "BuildGraph\n" if (DEBUG);

    my $all_macro_node = build_macro_nodes(graph => $graph);
    warn "BuildMacroNodes:" . Dumper($all_macro_node) if (DEBUG);

    my @internal_macro_node_ordered;
    my $start_time3 = [ gettimeofday ];

    my $pimn = ProcessInternalMacroNodes->new(
        init_data      => $init_data,
        graph          => $graph, 
        all_macro_node => $all_macro_node
    );

    foreach my $mn (@{$all_macro_node}) {

        my $mn_ordered = $pimn->resolve_internal_macro_node(
            macro_node     => $mn,
        );
        $mn_ordered->{name} = join(',', @{$mn});

        push @internal_macro_node_ordered, $mn_ordered;
    }
    warn "ResolverInternalMacroNode: " . Dumper(@internal_macro_node_ordered) if (DEBUG);

    # toma los macronodos y le agrega las variables de las cuales depende c/u
    get_vars_solved_in_other_mn(
        init_data           => $init_data,
        internal_macro_node => \@internal_macro_node_ordered
    );
    warn "GetVarsSolvedInOtherMN\n" if (DEBUG);

    # ahora tengo que ordenarlos externamente, tomo un macro nodo y busco cual es el orden 
    # en el que debe resolverse, cada macro nodo tiene ecuaciones y variables las cuales se 
    # resuelven en dicho macro node, pero hay ecuaciones que son parte de un macronode
    # y tiene variables que no son parte de dicho macronode, estas variables se resuelven en otro
    # macronode, asi que debo ordenarlos para que a la hora de resolver una determinada ecuacion
    # las variables que no son resueltas aqui ya esten calculadas
    my @ordered_graph = sort_macro_nodes(
        macro_nodes => \@internal_macro_node_ordered, 
    );

    warn "SortMacroNodes\n" if (DEBUG);

    # remover repetidos
    my @filter_ordered_graph = ();

    foreach my $og (@ordered_graph) {
        # chequear si ya existe
        my $exists = 0;
        foreach my $o (@filter_ordered_graph) {

            if ($og eq $o) {
                $exists = 1;
                last;
            }
        }

        # sino existe lo agrego
        unless ($exists) {
            
            push @filter_ordered_graph, $og;
        }
    }
    @ordered_graph = @filter_ordered_graph;
    # warn "ordered_graph: " . Dumper(@ordered_graph);
    # print " ####  X -> Y : Y debe resolverse antes que X  ####\n";

    my $directed_graph = Graph::Directed->new(); 

    my $macro_nodes;
    my $i = 1;
    foreach my $mn (@{$all_macro_node}) {
        $macro_nodes->{$i}->{name} = join(',', @{$mn});
        $macro_nodes->{$i}->{nodes} = $mn;
        $directed_graph->add_vertex($i);
        $i++;
    }

    foreach my $g_oder (@ordered_graph) {

        my ($first,$second) = split (DELIMITER, $g_oder);

        my ($f_num,$s_num);

        foreach my $n (keys $macro_nodes) {
            $f_num = $n if (join(',',@{$macro_nodes->{$n}->{nodes}}) eq $first);
            $s_num = $n if (join(',',@{$macro_nodes->{$n}->{nodes}}) eq $second);
        }

        $directed_graph->add_edge($f_num,$s_num);
    }

    my @topological_sort = $directed_graph->topological_sort;

    my $macro_nodes_ordered;

    my $j = @topological_sort;
    foreach my $i (@topological_sort) {
        $macro_nodes_ordered->{$j} = $macro_nodes->{$i};
        $j--;
    }

    my $result = {
        internal_macro_node_ordered => \@internal_macro_node_ordered,
        ordered_graph    => \@ordered_graph,
        all_macro_node   => $all_macro_node,
        topological_sort => [$macro_nodes_ordered]
    };

    my $elapsed = tv_interval( $start_time );
    print "Took: $elapsed\n";

    return $result;
}

1;