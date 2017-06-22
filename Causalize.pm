package Causalize;

use strict;
use warnings;
use Data::Dumper;
use Graph::Directed;

use lib "/Users/emanuel/Documents/personal/facultad/causalize";
use PreProcessData qw(:all);
use BuildGraph qw(:all);
use BuildMacroNodes qw(:all);
use ProcessInternalMacroNodes;
use VarSolvedInOtherMN qw(:all);
use SortMacroNodes qw(:all);
use Util qw(:all);
use Array::Utils qw(:all);
use Time::HiRes qw( gettimeofday tv_interval );

use constant DEBUG_PRE_PROCESS => 1;

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

    pre_process_data($init_data);

    my $data = build_graph(init_data => $init_data);

    my $graph = $data->{graph};

    my $graph_info = $data->{graph_info};

    my $all_macro_node = build_macro_nodes(graph => $graph);

    my @internal_macro_node_ordered;
    my $start_time3 = [ gettimeofday ];

    # esto se podria mover dentro de ProcessInternalMacroNodes
    my $node_info = get_equations_and_variables($graph);    

    $graph_info->{equations} = $node_info->{equations};
    $graph_info->{variables} = $node_info->{variables};

    my $pimn = ProcessInternalMacroNodes->new(
        init_data      => $init_data,
        graph          => $graph, 
        graph_info     => $graph_info, 
        all_macro_node => $all_macro_node
    );

    foreach my $mn (@{$all_macro_node}) {

        my $mn_ordered = $pimn->resolve_internal_macro_node(
            macro_node     => $mn,
        );
        $mn_ordered->{name} = join(',', @{$mn});

        push @internal_macro_node_ordered, $mn_ordered;
    }

    # toma los macronodos y le agrega las variables de las cuales depende c/u
    get_vars_solved_in_other_mn(
        init_data           => $init_data,
        internal_macro_node => \@internal_macro_node_ordered
    );

    # ahora tengo que ordenarlos externamente, tomo un macro nodo y busco cual es el orden 
    # en el que debe resolverse, cada macro nodo tiene ecuaciones y variables las cuales se 
    # resuelven en dicho macro node, pero hay ecuaciones que son parte de un macronode
    # y tiene variables que no son parte de dicho macronode, estas variables se resuelven en otro
    # macronode, asi que debo ordenarlos para que a la hora de resolver una determinada ecuacion
    # las variables que no son resueltas aqui ya esten calculadas
    my @ordered_graph = sort_macro_nodes(
        macro_nodes => \@internal_macro_node_ordered, 
        init_data   => $init_data, 
    );

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

    # print " ####  X -> Y : Y debe resolverse antes que X  ####\n";

    my $directed_graph = Graph::Directed->new(); 

    my $macro_nodes;
    my $i = 1;
    foreach my $mn (@{$all_macro_node}) {
        $macro_nodes->{$i} = $mn;
        $directed_graph->add_vertex($i);
        $i++;
    }

    foreach my $g_oder (@filter_ordered_graph) {

        my ($second,$first) = split (" -> ", $g_oder);

        my ($f_num,$s_num);

        foreach my $n (keys $macro_nodes) {
            $f_num = $n if (join(',',@{$macro_nodes->{$n}}) eq $first);
            $s_num = $n if (join(',',@{$macro_nodes->{$n}}) eq $second);
        }

        $directed_graph->add_edge($f_num,$s_num);
    }

    my @ts = $directed_graph->topological_sort;

    my $result = {
        internal_macro_node_ordered => \@internal_macro_node_ordered,
        ordered_graph    => \@filter_ordered_graph,
        all_macro_node   => $all_macro_node,
        topological_sort => [$macro_nodes, {order => \@ts}]
    };

    my $elapsed = tv_interval( $start_time );
    print "Took: $elapsed\n";

    return $result;
}

sub get_equations_and_variables {
    my $graph = shift;

    my (@equations,@variables);
    my @vertices = $graph->vertices;

    foreach my $node (@vertices) {
        my $type = $graph->get_vertex_attribute($node, 'type');
        if ($type eq 'EQ') {
            push @equations, $node;
        } elsif($type eq 'VAR') {
            push @variables, $node;
        } else {
            die "Error. Node: $node type: $type";
        }
    }

    my $data = {
        equations => \@equations,
        variables => \@variables
    };

    return $data;
}

1;