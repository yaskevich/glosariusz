#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use DBI;
use autodie qw(:all); # apt-get install libipc-system-simple-perl

use Mojo::DOM;
binmode(STDOUT, ":utf8");
use Data::Printer; #  apt-get install libdata-printer-perl


my $dbh = DBI->connect("dbi:SQLite:glos.db","","", {sqlite_unicode => 1,  AutoCommit => 0, RaiseError => 1}) or die "Could not connect";
my $sql  = "INSERT INTO slownik (title, qty, auth, srclist, body, pnum, entype, ref_targets)  VALUES (?, ?,?,? , ?, ?,?,?)";
my $sth = $dbh->prepare($sql);
# exit;


open my $ind, '>:encoding(UTF-8)', "new/"."index.txt";
	
	# $new = in_span ($new, '´', 'ā́', 'a', '¯');  # a<span class="s8">´</span>¯
sub in_span {
		# <p class="s3" style="padding-top: 1pt;text-indent: 0pt;text-align: left;">X <span class="p">
		my ($str, $sym, $to, $pre, $post) = @_;
		
		my $re = '';
		$re .= $pre if $pre;
		$re .= quotemeta('<span class="s').qr/\d{1,2}/.quotemeta('">').quotemeta($sym).qr/(\s*)/.quotemeta('</span>');
		$re = $re.$post if $post;
		# $str =~ s/$re/$to$1/g;
		$str =~ s/$re/$to/g;
		return $str;
  }


my $all = '<!DOCTYPE html>'."\n".'<html><head><meta charset="utf-8"/></head><body>§'."\n";

my @files = 1..544;
foreach my $file (@files) {
  # print $file . "\n";
  # my $new = "\n\n".proc ($file.".html");
  # my $new = "\n⌠$file⌡\n".proc ($file.".html");
  my $new = proc ("root/".$file.".html");
  $new = "\n[p:$file]\n".$new;
  
  $new =~ s/h1/p/g;
  $new =~ s/h2/p/g;
  $new =~ s/h3/p/g;
  
  # $new =~ s/\<span class\=\"s\d{1,2}\"\>([´˙])\<\/span\>/$1/g; # what's that? disabled now.
  my $usls_br = quotemeta ('<p><br></p>');
  $new =~ s/$usls_br//g;
  
  
  $new =~ s/\<p\>˘\<\/p\>//g; # maybe not do to recover diacritics?
  
  
  
  my $spans5 =quotemeta('</span>´<span class="s5">S');
  my $spans5p =quotemeta('S</span>´<span class="s5">');
  $new =~ s/$spans5/Ś/g;
  $new =~ s/$spans5p/Ś/g;
  
  
  # <span class="s9">Z</span>´
  

  
  my $spanNG = quotemeta('<span class="s1">flj</span>');
  $new =~ s/$spanNG/ɳ/g;
  
  
  my $spanX = quotemeta('<span class="s6">X</span>');
  
  # <span class="s3">X </span>
  
  
  $new = in_span ($new, 'X', 'χ');
  # $new =~ s/X\s?/χ/g; # XVI st
  
  $new = in_span ($new, '~', 'õ', 'o'); # o<span class="s6">~</span>
  $new = in_span ($new, '´', 'ā́', 'a', '¯');  # a<span class="s8">´</span>¯
  $new = in_span ($new, '3', 'ə'); # pel(<span class="s7">3 </span>)
  $new = in_span ($new, '´', 'ř́', 'ˇ', 'r');  # patˇ<span class="s9">´</span>r
  $new = in_span ($new, '´', 'ā́', '', 'a¯');  # <span class="s8">´</span>a¯ti «ochrania´c
  $new = in_span ($new, '–', 'ȁ', 'a');  # <a<span class="s7">–</span> # chorw
  $new = in_span ($new, '´', '́š', '', 'ˇs');  #<span class="s12">´</span>ˇs
  
  
  $new = in_span ($new, 'Z', 'ʒ'); # <span class="s9">Z</span>
  $new = in_span ($new, 'Z', 'ʒ́', '', '´'); # <span class="s9">Z</span>´
  
  
  
  
  # Labiovelars, */kʷ/, */gʷ/, */gʷʰ/ (also transcribed */ku̯/, */gu̯/, */gu̯h/). 
  $new = in_span ($new, 'u', 'ʷ');   # <span class="s10">u</span> !!! in text must be superscript of u̯
  
  my $tilde = '̃';
  $new = in_span ($new, '~', $tilde); #lit. im<span class="s9">~</span><span class="s10"> </span>ti «wzia˛´c
  
  $new = in_span ($new, '´', 'Ś', 'S'); # S<span class="s4">´</span>
  $new = in_span ($new, '´', 'Ś', '', 'S'); # <span class="s3">´</span>S
  $new = in_span ($new, '˙', 'Ż', 'Z'); # Z<span class="s3">˙</span>
  
  $new = in_span ($new, 'h', 'ʰ'); # <span class="s9">h</span> # pie
  
  
  $new = in_span ($new, ' ', '█'); # <span class="s10"> </span>
  
  
  
		
  
  
  my $spans7cb = quotemeta('<span class="s').qr/\d/.quotemeta('">}').qr/(\s*)/.quotemeta('</span>');
  # my $spans7cb = quotemeta('<span class="s7">}</span>');
  
  # roz- wo´j: zach.słow. *<span class="s6">X</span>lop<span class="s7">}</span>j<span class="s7">} </span>? stpol. 
  # rozwój: zach.słow. *χlopьj } → stpol. χłopi.   
  $new =~ s/$spans7cb/ь$1/g;
  
  
  $new =~ s/\<i\>}(\s*)\<\/i\>/ь$1/g;
  
  # 
  my $spans7cbl = quotemeta('<span class="s').qr/\d/.quotemeta('">{').qr/(\s*)/.quotemeta('</span>');
  $new =~ s/$spans7cbl/ъ$1/g;
  
  
  
  my $spanA_cz = quotemeta('a<span class="s8">–</span>');
  $new =~ s/$spanA_cz/ȁ/g;
  
  ##################
  # simple clean
  
  $new =~ s/¯ı/ī/g;
  $new =~ s/´ı/í/g;
  $new =~ s/a¯/ā/g;
  $new =~ s/´v/́v/g;
  $new =~ s/ˇc/č/g;
  $new =~ s/ˇs/š/g;
  $new =~ s/aˇ/ǎ/g;
  $new =~ s/u¯/ū/g; # stind
  $new =~ s/`ı/ì/g; # lith
  $new =~ s/ˇr/ř/g; # stpol
  $new =~ s/´e/é/g; # sloweń
  $new =~ s/´g/ǵ/g; # pie
  $new =~ s/`e/è/g; # sch
  $new =~ s/´y/ý/g; # ros
  $new =~ s/¯e/ē/g; # pie
  
  # must be after sinple diacritics
  
  
	my $acute = '́';
	# <span class="s9">´</span>
	my $re = quotemeta('<span class="s').qr/\d{1,2}/.quotemeta('">').quotemeta('´').qr/(\s*)/.quotemeta('</span>').qr/(\S)/;
	$new =~ s/$re/$2$acute/g; # maybe wrong place of acute: psl. č́ , p. 41
  
  
  
  
   
  # then go to p. 100
  
  
  $new =~ s/\?(?=\s|\<)/ → /g;
  $new =~ s/(?<=[\;\ː\.\,\-\w])\/(?=\s)/ ¶ /g;
  $new =~ s/\/(?=\s)/ ← /g;
   
  
  
  $new = clean($new);
  
  
  $new =~ s/(?<=\w)´/́/g;
  
  
  
  $new =~ s/&lt;/‹/g;
  $new =~ s/&gt;/›/g;
  
  $new =~ s/ \? / → /g;
  
  $new =~ s/(?<=\>)\{(?=\<)/ъ/g;
  
  # $new =~ s/D\s+\<span class\=\"p\"\>por\.\s(.*?)\.\<\/span\>/Δ ≡ $1/g;
  $new =~ s/\<p\>\<br\>\<\/p\>//g;
  
  
  $new =~ s/\>D\s+\</\>\<br\/\>\n\nΔ\</g;
  
  $new =~ s/\<p class\=\"s\d+\"\>\s*([A-ZŚŻŹŃĄĘŁĆ])\s*\<\/p\>//g;
  # print "Letter".$1."\n" if $1;
  
  
  $new =~ s/oó/ó/g; # for some reason ó somewhere exported from pdf as oó
  
  my $macron = '̄';
  my $breve = '̆';
  $new =~ s/¯/$macron/g;
  $new =~ s/˘/$breve/g;
  
  
  
  # $new =~ s/(?<=[§])(.*?)(?=\(\d+)/⌠$file⌡ $1/;
  # $all .= $new."\n\[file:$file\]\n";
  $all .= $new."\<p class=\"page$file\"\>\<\/p\>";

  
  
	open my $one, '>:encoding(UTF-8)', "new/".$file.".html";
	print {$one} $new;
	close $one;
  
}

	open my $newout, '>:encoding(UTF-8)', "newout.txt";
	open my $newindex, '>:encoding(UTF-8)', "newindex.txt";
	# 
	# $all =~ s/([A-Z\-]+)(.*?)(?=\<p[\>\s])/\[auth:$1\]$2\n\<hr\/\>\n\n§/g;
	$all =~ s/(KDK|WD|AK|IS|IW\-G|JG|BT|HK|ZG|AP)(.*?)(\<.*?)(?=\<p[\>\s])/\[auth:$1 $2\]$3\n\<hr\/\>\n\n§/g;
	open my $out, '>:encoding(UTF-8)', "GS.html";
	print {$out} $all;
	print {$out} '</body></html>';
	
	my @twords; # = ($new =~ m/(?<=§)(.*?)(?=\(\d+)/g);
	my @ref_c = ($all =~ m/\((\d+)\)/g);
	
	my @entries = split (/§/, $all);
	
	my $not_match= 0;
	my $match_ok= 0;
	
	my $pnum = 0;
	foreach my $entry (@entries) {
		# if ($entry =~ m/^(.*?)(?=\((\d+)\))/){
			# say $newout $1//'<err>';
			# say $newout $2//'{?}';
		# }
		# $entry =~ s/^\s+//;
		my $this_content = Mojo::DOM->new($entry)->all_text();
		next unless $this_content;
		# say $newout "|$entry|";
		
		$this_content =~ s/Z\s+˙\s+/Ż/;
		$this_content =~ s/\s+(ь|ъ)(?=[\s\:\;\.\,\?]+)/$1/g;
		$this_content =~ s/j\s+ь/jь/g;
		
		$this_content =~ s/^[˚˘\s]+//;
		
		# $this_content =~ s/\-\s+//g;
		$this_content =~ s/\s+–\s+█(?=\S)//g;
		$this_content =~ s/█//g;
		$this_content = clean($this_content);	
		$this_content =~ s/(?<=\w)(?=«)/ /;
		
		$this_content =~ s/\s+/ /;
		
		$this_content =~ s/Z\s+˙\s+/Ż/g;
		$this_content =~ s/\s+´\s+S/Ś/g;
		$this_content =~ s/\s+´\s+S/Ś/g;
		
		
		# removing USEFUL markup!!!
		# page num -> should be EXTRACTED!
		
		
		if ($this_content =~ s/\[p\:(\d+)\]\s//){
			$pnum = $1;
			say $newout "#".$pnum;
		}
		
			
		my $pos = 0;
		my $en_title;
		my $en_qty;
		my $en_src;
		my $en_auth;
		my $type ='?';
		
		my $remark_re = qr/w|tylko|I\sw/;
		
	if($this_content =~ m/^(.*?)\s+\((\d+)\)\s+\[(.*?)\](\s+)(?=Δ|$remark_re)/){ # spec parsing of W !
			$pos += $+[$#+]; # looool i'm Perl coder %)

			# say $newout "*".$pos."*";
			$en_title = (defined $1 && length($1)) ? $1 : '<error>';
			
		
			
			
			$en_qty = (defined $2 && length($2)) ? $2 : '{?}';
			$en_src = (defined $3 && length($3)) ? $3 : '!!!';

			
			$en_title =~ s/[̆˚˘]//g;
			$en_title=~ s/^\s+//g;
			
			say $newout "■ ".$en_title;
			say $newout $en_qty;
			say $newout $en_src;
			
			my $rest = substr($this_content, $pos);
			
			($rest, $en_auth) = split (/\s+\[auth\:/, $rest);
			
			
			
			# chop($en_auth);
			$en_auth = $en_auth ? substr($en_auth, 0, -1) : '@@';
			say $newout "@".$en_auth;
			$type = ' ';
			
			my @deltas = split (/(?=Δ)/,$rest); # could be text BEFORE delta !
			
			foreach my $delta (@deltas) {
				
				
				unless  ($delta  ~~ [
									qr/^Δ\szn\./,
									qr/^Δ\sgram\./,
									qr/^Δ\sformy\stekstowe\:/, 
									qr/^Δ\setym\./, 
									qr/^Δ\srozwój\:/, 
									qr/^Δ\spor\.\s/, 
									qr/^Δ\szob\.\s/,
									$remark_re
									] ){
					say $newout "!!!".$delta;
					++$not_match;
				} else {
					$delta =~ s/(?<=\.)\s+(\d)\.(?=\s)/\n● ($1)/g if $delta =~ qr/^Δ\szn\./;
					say $newout $delta;
				}
			}
			
			++$match_ok;
			
			# title, qty, auth, srclist, body, pnum, entype, ref_targets
			$sth->execute ($en_title, $en_qty, $en_auth, $en_src, $rest, $pnum, 0, '')  or die "Couldn't execute statement: " . $sth->errstr;
			$sth->finish();
			
		} elsif($this_content =~ m/^(.*?)\s+zob\.\s+(.*?)\s+\[auth\:(.*)\]$/){
			# dziano zob. dziać. [auth:WD]
			say $newout "►".$1."→".$2."\n@".$3;
			$en_title = $1;
			$en_auth = $3;
			my $en_targets = $2;
			$en_targets =~ s/\.//g;
			
			$type = '>';
			
			if (length($en_title) > 15) {
				say $newout "!!!";
				++$not_match;
			} else {
				++$match_ok;
			}
			
			# title, qty, auth, srclist, body, pnum, entype, ref_targets
			$sth->execute ($en_title, 0, $en_auth, '', '', $pnum, 1, $en_targets)  or die "Couldn't execute statement: " . $sth->errstr;
			$sth->finish();
		} 
		else {
			# say STDERR $this_content;
			++$not_match;
			say $newout "!!!";
			print $newout substr($this_content, $pos);
		}
		
		
		say $newindex  "[".sprintf("%03d", $pnum)."][$type]\t".$en_title if $en_title;
		
		
		print $newout "\n";
		# print $newout '=' x 50;
		print $newout "\n";
	}
	$dbh->commit();
	$dbh->disconnect();

	say STDERR $match_ok." vs ".$not_match;
	####################################################################
	
				# push @twords, [$1, $2] while $all =~ m/(?<=§)(.*?)(?=\((\d+)\))/g;
					# # print {$ind} p @twords;
					# # print {$ind} "======================\n>>Page: ".$file."\n>>Words:".scalar (@twords);
				# my $ind_report = '';
					# # print {$ind} " !!! ".scalar(@ref_c) if scalar (@twords) != scalar(@ref_c);
					# # print {$ind} "\n";
				# my $probs = 0;
				# foreach my $it (@twords){
					# my ($title, $count ) = @{$it};
					# $title =~ s/[˚˘]//g;
					# my $dom2 = Mojo::DOM->new($title);
					# my $ind_line = $dom2->all_text;;
					# unless ($ind_line) {
						# $ind_line = "\t".'<PROBLEM>';
						# $probs++;
					# }
					# $ind_report .= $ind_line.": ".$count."\n";
				# }
				
				# print {$ind} ">>All: ".scalar(@ref_c)." Marked: ".scalar (@twords)." Not recognized: ".$probs."\n";
				# print {$ind} $ind_report;
	
	  # print {$ind} '>>>'.$ind_line.": ".$file."\n";
	# $ind_line = '<PROBLEM-NOT-FOUND>'
  
	# my @matches = ($all =~ m/([A-Z]{2,3})\s.(*?)(\(\d+\))\s\[(.*?)\]/g);
	
	# my @matches;
	# push @matches, [$1, $2, $3, $4] while $all =~ m/([A-Z]{2,3})\s(.*?)(\(\d+\))\s\[(.*?)\]/g;
	
	# print p @matches;
	# exit;
	
	close $ind;
	close $out;

sub proc {

my ($filename) = @_;
my $content="";

open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
  chomp $row;
  # print "$row\n";
  $content.=$row;
}
# print "done\n";

# exit;


my $dom = Mojo::DOM->new($content);
# $dom->find('style')->map('remove');
# $dom->find('title')->map('remove');
$dom->find('head')->map('remove');
# print "\n\n";
# print $dom->all_text;
# return $dom->all_text;
# return $dom->children('html > body')->join("\n");
# $dom->find('[style]')->attrs(style => '');

$dom->find('*')->each(sub {
    delete $_->{style};
});

return $dom->find('body')->map("content")->join("\n");
 # root->children('html > body')->join("\n");;

}

sub clean {
	my ($new) = @_;
	my $bad_p = quotemeta('-</p><p>');
  
  $new =~ s/$bad_p//g;
  
  $new =~ s/\-\s(?=[a-zśżźńąęłć])//g;
  
  $new =~ s/z˙/ż/g;
  $new =~ s/Z˙/Ż/g;
  $new =~ s/˙z/ż/g;
  $new =~ s/˙Z/Ż/g;
  
  $new =~ s/z´/ź/g;
  $new =~ s/Z´/Ź/g;
  
  
  
  $new =~ s/´z/ź/g;
  $new =~ s/´Z/Ź/g;
  
  
  $new =~ s/´s/ś/g;
  $new =~ s/´S/Ś/g;
  
  $new =~ s/s´/ś/g;
  $new =~ s/S´/Ś/g;
  
  
  $new =~ s/´c/ć/g;
  $new =~ s/´C/Ć/g;
  
  $new =~ s/a˛/ą/g;
  $new =~ s/o´/ó/g;
  
  
  $new =~ s/˜a/ã/g;
  $new =~ s/a`/à/g;
  
  
  $new =~ s/ˇz/ž/g;
  $new =~ s/cˇ/č/g;
  $new =~ s/e˛/ę/g;
  $new =~ s/ˇe/ě/g;
  $new =~ s/n´/ń/g;
  $new =~ s/˛e/ę/g;
  $new =~ s/o¸/ǫ/g;
  # $new =~ s/}/ь/g;
	return $new;
}
