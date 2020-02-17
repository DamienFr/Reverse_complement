#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;

=head1 DESCRIPTION

	Reverse-complement sequence(s) from a fasta file containing one or multiple sequences.

=head1 USAGE

	perl Reverse_complement.pl -fasta input.fasta [-out output.fasta] 
	-h or -help:	This Documentation

=head1 OUTPUT

	[input.fasta].rev_comp or [-out output.fasta] if specified

=head1 AUTHOR

	Damien Richard, 2019

=cut

my ($hl,$fasta, $output);

GetOptions(
	"fasta=s" => \$fasta,
	"out=s" => \$output,
	"h|help" => \$hl
);

if(! $output){ $output = $fasta . "rev_comp"}

die `pod2text $0` if $hl;

my %hhh;

open( OUT, ">", $output ) or die "can't open $!";

# reading input fasta file WITH Bio::SeqIO;
my $fasta_in = Bio::SeqIO->new( -file => $fasta, -format => 'Fasta' );
while ( my $seq = $fasta_in->next_seq() ) {
    my $title_provisoire = $seq->id;
    if ( exists( $hhh{ $seq->id } ) ) {
        print "\nTwo sequence titles have the exact same name : $title_provisoire, i'll die now ...\n"; die;
    }
    $hhh{ $seq->id } = 1;
    my $sequence = $seq->seq();
    my $revcomp = reverse($sequence);

    # complement the reversed DNA sequence
    $revcomp =~ tr/ABCDGHMNRSTUVWXYabcdghmnrstuvwxy/TVGHCDKNYSAABWXRtvghcdknysaabwxr/;

    #tous les 60 caractres insérer un saut de ligne
    #$revcomp =~ s/(.{1,60})/$1\n/gs;

    print OUT ">" . $title_provisoire . "_rev_comp\n" . $revcomp . "\n";
}
my $nb = scalar keys %hhh;
print "\tJob done, $nb sequence(s) reverse complemented\n";

close OUT;

