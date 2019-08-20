#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;

=head1 DESCRIPTION

	Reverse-complement sequence(s) from a fasta file containing one or multiple sequences.

=head1 USAGE

	perl Reverse_complement.pl input.fasta

=head1 OUTPUT

	[input.fasta].rev_comp
	-h or -help:	This Documentation

=head1 AUTHOR

	Damien Richard, 2019

=cut

my $hl;

GetOptions(
	"h|help" => \$hl,
);

die `pod2text $0` if $hl;

my $fasta = $ARGV[0];
chomp $fasta;
my $output = $fasta . "rev_comp";
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


