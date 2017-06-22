use strict;
use warnings;
use Data::Dumper;

use Exporter qw(import);
our @EXPORT_OK = qw( pre_process_data );
our %EXPORT_TAGS = (
    'all' => \@EXPORT_OK,
);


## f:10 a 20 - g: 10 a 30 - h:1 a 20  
## f:              10--------20
## g:              10---------------------30
## h:   1--------------------20
##
##      1           10        20           30
## -----|---------|-|----------|-|----------|----
## min_index_ran  9              21        max_index_ran
##
## all_ran:
##      1<------>9 10<------->20 21<------>30
##      


sub pre_process_data {
    my $init_data = shift;

    my $needs_modification = 0;
    my $data = {};
    foreach my $eq (keys %{$init_data}) {
        if($init_data->{$eq}->{ran} and $needs_modification == 0) {
            my ($init_eq,$end_eq);

            $init_eq = $init_data->{$eq}->{ran}->{0}->{init};
            $end_eq  = $init_data->{$eq}->{ran}->{0}->{end};

            if ($init_eq > $end_eq) {
                my $tmp  = $init_eq;
                $init_eq = $end_eq;
                $end_eq  = $tmp;
            }

            if ($data) {
                foreach my $e (keys %{$data}) {
                    my $min = $data->{$e}->{min};
                    my $max = $data->{$e}->{max};

                    if ($min > $max) {
                        my $tmp  = $min;
                        $min = $max;
                        $max = $tmp;
                    }

                    if ($init_eq == $min and $max == $end_eq ) {
                        next;
                    }

                    if ($max < $init_eq ) {
                        last;
                    }

                    if ($init_eq > $max) {
                        next;
                    }

                    $needs_modification = 1;
                }
            }

            $data->{$eq} = {
                min => $init_eq,
                max => $end_eq
            };
        }
    }

    return unless ($needs_modification);

    warn "The init data must be modified!!\n";

    my $all_ran = _get_all_ran($init_data);

    my @keys_init_data = keys %{$init_data};
    foreach my $eq (@keys_init_data) {
        if($init_data->{$eq}->{ran}) {
            my @ran_keys = sort(keys %{$all_ran});

            foreach my $k (@ran_keys) {
                my $min_index_ran = $all_ran->{$k}->{min};
                my $max_index_ran = $all_ran->{$k}->{max};

                my ($init_eq,$end_eq);

                $init_eq = $init_data->{$eq}->{ran}->{0}->{init};
                $end_eq  = $init_data->{$eq}->{ran}->{0}->{end};

                if($min_index_ran>=$init_eq and $max_index_ran <= $end_eq) {
                    if($min_index_ran == $max_index_ran) {

                        $init_data->{"$eq$min_index_ran"}->{ran} = "";

                            $init_data->{"$eq$min_index_ran"}->{ran} = "";

                            foreach my $var (keys %{$init_data->{$eq}->{var_info}}) {


                                my $ran_index = $init_data->{$eq}->{var_info}->{$var}->{ran};
                                $ran_index = $init_data->{$eq}->{ran} unless ($ran_index);

                                my @constant = ();
                                @constant = @{$init_data->{$eq}->{var_info}->{$var}->{constant}} if ($init_data->{$eq}->{var_info}->{$var}->{constant});

                                foreach my $index (keys %{$ran_index}) {
                                    my $new_index = $min_index_ran + $index;
                                    push @constant, $new_index;
                                }

                                # esta es la nueva ecuacion
                                $init_data->{"$eq$min_index_ran"}->{var_info}->{$var} = {
                                    ran      => "",
                                    constant => \@constant
                                };
                            }
                    } 
                    else {
                        my $new_var_info;
                        foreach my $var (keys %{$init_data->{$eq}->{var_info}}) {
                            
                            unless($init_data->{$eq}->{var_info}->{$var}->{ran}) {
                                $new_var_info = $init_data->{$eq}->{var_info};
                                next;
                            }
                            my @index_keys = keys %{$init_data->{$eq}->{var_info}->{$var}->{ran}};
                            foreach my $index (@index_keys) {
                                $new_var_info->{$var}->{ran}->{$index} = {
                                    init => $min_index_ran+$index,
                                    end  => $max_index_ran+$index
                                };
                            }
                            $new_var_info->{$var}->{constant} = $init_data->{$eq}->{var_info}->{$var}->{constant} || '';
                        }
                        my $init_data_int = {
                                ran      => {
                                    0 => {
                                        init => $min_index_ran,
                                        end  => $max_index_ran,
                                        vars => $init_data->{$eq}->{ran}->{0}->{vars}
                                    }
                                },
                                var_info => $new_var_info || ""
                        };
                        $init_data->{"$eq$min_index_ran$max_index_ran"} = $init_data_int;
                    }
                }
            }
            delete $init_data->{$eq};
        }
    }
    # chequeo que todo haya quedado bien
    check_ran($init_data);
}

sub _get_all_ran {
    my $data = shift;

    my $min_index_ran;
    my $max_index_ran;

    # busco el minimo y maximo valor de todos los rangos
    foreach my $eq (keys %{$data}) {
        if($data->{$eq}->{ran}) {
            my ($init_eq,$end_eq);
            $init_eq = $data->{$eq}->{ran}->{0}->{init};
            $end_eq  = $data->{$eq}->{ran}->{0}->{end};

            $min_index_ran = $init_eq unless($min_index_ran);
            $max_index_ran = $end_eq unless($max_index_ran);
            
            if ($min_index_ran > $init_eq) {
                $min_index_ran  = $init_eq;
            }

            if ($min_index_ran > $end_eq) {
                $min_index_ran  = $end_eq;
            }            

            if ($max_index_ran < $init_eq) {
                $max_index_ran  = $init_eq;
            }

            if ($max_index_ran < $end_eq) {
                $max_index_ran  = $end_eq;
            }
        }
    } 

    my $all_ran = {};

    my $next_min_index_ran = $min_index_ran;
    my $next_max_index_ran = $max_index_ran;

    my $i=1;
    my $find_ran = 1;
    while($find_ran) {
        $next_max_index_ran = $max_index_ran;
        
        foreach my $eq (keys %{$data}) {

            if($data->{$eq}->{ran}) {
                my ($init_eq,$end_eq);
                $init_eq = $data->{$eq}->{ran}->{0}->{init};
                $end_eq  = $data->{$eq}->{ran}->{0}->{end};

                if ($init_eq > $end_eq) {
                    my $tmp  = $init_eq;
                    $init_eq = $end_eq;
                    $end_eq  = $tmp;
                }
                
                # el indice de next_max_index_ran debe ser mayor a next_min_index_ran 
                # y mayor al anterior rango guardado
                if($init_eq < $next_max_index_ran and $init_eq > $next_min_index_ran) {
                    $next_max_index_ran = $init_eq;
                }
                elsif($end_eq < $next_max_index_ran and $end_eq > $next_min_index_ran ) {
                    $next_max_index_ran = $end_eq;
                }
            }
        }

        my $next_max = $next_max_index_ran-1;

        # me fijo si hay algun rango que sea igual al que tengo si es asi dejo ese
        # si tengo 10 a 20 y esta ese rango lo dejo, sino va de 10 a 19
        foreach my $eq (keys %{$data}) {
            if($data->{$eq}->{ran}) {
                my ($init_eq,$end_eq);
                $init_eq = $data->{$eq}->{ran}->{0}->{init};
                $end_eq  = $data->{$eq}->{ran}->{0}->{end};

                if($init_eq == $next_min_index_ran && $end_eq == $next_max_index_ran) {
                    $next_max = $next_max_index_ran;
                }
            } 
        }

        $all_ran->{$i} = {
            min => $next_min_index_ran,
            max => $next_max
        };
        $i++;
        $next_min_index_ran = $next_max+1;

        if($next_max_index_ran == $max_index_ran) {
            $find_ran = 0;
            if ($all_ran->{$i-1}->{max}+1 <= $max_index_ran) {
                $all_ran->{$i-1}->{max} = $all_ran->{$i-1}->{max}+1;
            }
        }
    }
    return $all_ran;
}

sub check_ran {
    my $init_data = shift;

    my ($init_eq,$end_eq);
    foreach my $eq (keys %{$init_data}) {
        if($init_data->{$eq}->{ran}) {
            unless($init_eq && $end_eq) {
                $init_eq = $init_data->{$eq}->{ran}->{0}->{init};
                $end_eq  = $init_data->{$eq}->{ran}->{0}->{end};
            }

            my $init = $init_data->{$eq}->{ran}->{0}->{init};
            my $end = $init_data->{$eq}->{ran}->{0}->{end};

            if($init_eq ne $init or $end_eq ne $end) {
                die "Wrong equation range";
            }
        }
    }
}

1;