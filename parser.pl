use Modern::Perl;
use Data::Dumper;
use IO::All;
use HTML::Parser;
use LWP::Simple;
use DBI;
use Smart::Comments;

my $dbh = DBI->connect("dbi:SQLite:dbname=local.db","","");
my $sth = $dbh->prepare("DELETE FROM urls");
$sth->execute();

my $p = HTML::Parser->new( api_version => 3,
                         start_h => [\&start, "tagname, attr"],
                         end_h   => [\&end,   "tagname"],
                         marked_sections => 1,
                       );
        
for (io('data/')->all)
    {
#         say Dumper($p->parse_file($_));
#         $_ > io('output/' . $_ . '.txt');# 
#         
#         my $htmlstring = "<p>ok</p><table>here";
#         say Dumper(html( \$htmlstring, \%handlers_to_keep_only_tables ));
    }
    
foreach ("0001" .. "7000") { ### Mirroring |===[%]
my $response = get("http://data.parliament.uk/writtenevidence/WrittenEvidence.svc/EvidenceHtml/$_");
my $sth = $dbh->prepare("INSERT INTO urls VALUES (?, ?)");
$sth->execute($_, $response);
}