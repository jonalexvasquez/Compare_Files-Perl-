use Data::Dumper;
use strict;

open(my $fh1,"BEFORE_FILE") or die"ERROR";
open(my $fh2,"AFTER_FILE") or die "ERROR";
my @array1=<$fh1>;
my @array2=<$fh2>;
chomp(@array2);
close($fh1);
close ($fh2);
my %file2=();
my %hash;
my %hash2;
close $fh1;
close $fh2;
my $key;
my $key2;
open(my $fh_1,"<BEFORE_FILE") or die"ERROR";
open(my $fh_2,"<AFTER_FILE") or die "ERROR";
open(my $fh_3, ">DIFF_LOG")or die "Error";
while(<$fh_1>) {
    chomp;
    my $line=$_;
    if (/===/) {
        $key = $line;
        $hash{$key} = ();
    } else {
        push @{$hash{$key}}, $_;
    }
}
close $fh_1;
while(<$fh_2>) {
    chomp;
    my $line=$_;
    if (/===/) {
        $key2 = $line;
        $hash2{$key2} = ();
    } else {
        push @{$hash2{$key2}}, $_;
    }
}
foreach my $_key (sort keys %hash) {
    print $_key."\n";
    print $fh_3 "$_key\n";
    my @temp_array=@{$hash{$_key}};
    my @second_array= &_bridge(\@temp_array,\%hash2);
    &_compare(\@temp_array,\@second_array,$fh_3);
    delete $hash2{$_key};
}
close $fh_2;
close $fh_3;
sub _bridge {
    my $array_ref = shift;
    my $_hash_ref=shift;
    my @first_array = @{$array_ref};
    my %_hash2=%{$_hash_ref};
    my $counter2=0;
    my @new_array;
    foreach my $_key2 (sort keys %_hash2) {
         @new_array = @{$_hash2{$_key2}};
         return @new_array;
    }
}
sub _compare {
    my $array=shift;
    my $array2=shift;
    my $fh=shift;
    my @array_1 = @{$array};
    my @array_2=@{$array2};
    my @loop_array=();
    if(scalar @array_1>scalar @array_2){
        @loop_array=@array1;
    }
    elsif(scalar @array_2>scalar @array_1){
        @loop_array=@array_2;
    }
    else{
        @loop_array=@array_1;
    }
    for my $i(0 .. $#loop_array){
        if($array_1[$i] ne $array_2[$i]){
            print "\n+$array_1[$i]\n-$array_2[$i]\n";
            print $fh "\n+$array_1[$i]\n-$array_2[$i]\n";
        }
    }
}


