#!/usr/bin/env perl

# Author: philsmd
# License: public domain
# First released: January 2015

use strict;
use warnings;

use MIME::Base64;

# should we use json modules instead?
# shouldn't really matter anyway

#
# Helper functions
#

# read entire file into memory

sub read_file
{
  my $file_name = shift;

  my $string = "";

  local $/ = undef;

  if (! open (FILE, "<$file_name"))
  {
    print "ERROR: could not open input file '$file_name'\n";

    exit (1);
  }

  binmode FILE;

  $string = <FILE>;

  close FILE;

  return $string;
}

sub usage ()
{
  print "usage: $0 input_file [output_file]\n\n";
  print "OPTIONS:\n";
  print "--h | --help      display this usage info\n";
}

#
# Start
#

# check arguments

if (scalar (@ARGV) < 1)
{
  print "ERROR: please specify the path to the encryptionKeys.js file as first command line argument\n\n";

  usage ();

  exit (1);
}

# -h or --help

if (($ARGV[0] eq "--help") || ($ARGV[0]) eq "-h")
{
  usage ();

  exit (0);
}

# stdout or custom output file

my $input_file  = $ARGV[0];

my $output_file = "";
my $fp;

if (scalar (@ARGV) > 1)
{
  $output_file = $ARGV[1];

  if (! open ($fp, ">$output_file"))
  {
    print "ERROR: could not open the output file\n";

    exit (1);
  }
}
else
{
  $fp = *STDOUT;
}

my $file_content = read_file ($ARGV[0]);

my @splitted_list = split (/"data"/, $file_content);

my $list_size = scalar (@splitted_list);

if ($list_size < 2)
{
  print "ERROR: the file specified does not contain any valid data\n";

  exit (1);
}

# loop

for (my $i = 1; $i < $list_size; $i++)
{
  my $str = $splitted_list[$i];

  # get the "data" item

  my $data_start = index ($str, '"');

  next if ($data_start < 0);

  $data_start++;

  my $data_end = index ($str, '"', $data_start);

  next if ($data_start < 0);

  my $data = substr ($str, $data_start, $data_end - $data_start);

  $data =~ s/\\u0000$//;

  $data = decode_base64 ($data);

  # salt

  my $salt = "\x00" x 16;

  if ($data =~ m/Salted__/)
  {
    $salt = substr ($data,  8, 8);
    $data = substr ($data, 16);
  }

  # get the "iterations" item

  my $iteration_tag_start = index ($str, "iterations");

  next if ($iteration_tag_start < 0);

  my $iteration_tag_end = index ($str, '"', $iteration_tag_start);

  next if ($iteration_tag_end < 0);

  $iteration_tag_end++;

  my $iteration_start = index ($str, ':', $iteration_tag_end);

  next if ($iteration_start < 0);

  $iteration_start++;

  my $iteration = substr ($str, $iteration_start);

  $iteration =~ s/^ *([0-9]*).*$/$1/;
  $iteration =~ s/\n//g;

  # print it 

  my $salt_hex = unpack ("H*", $salt);
  my $data_hex = unpack ("H*", $data);

  print $fp $iteration . ":" . $salt_hex . ":" . $data_hex . "\n";
}

if (length ($output_file) > 0)
{
  print "output was successfully written to the file '$output_file'\n";
}

close ($fp);

exit (0);
