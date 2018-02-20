#!/usr/bin/perl

print <<EOT;
// generated by txt2c.pl from $ARGV[0]
#include "stdafx.h"

#include <stdlib.h>
EOT

for $manual (<manual*txt>) {

    if($manual eq 'manual.txt') {
        $name = "HelpText";
        # Some languages don't have translated manuals yet, so use English
        $ifdef = "#if defined(LDLANG_EN) || " .
                     "defined(LDLANG_ES) || " .
                     "defined(LDLANG_IT) || " .
                     "defined(LDLANG_JA) || " .
                     "defined(LDLANG_FR) || " .
                     "defined(LDLANG_TR) || " .
                     "defined(LDLANG_RU) || " .
                     "defined(LDLANG_PT)";
    } elsif($manual =~ /manual-(.)(.)\.txt/) {
        $p = uc($1) . lc($2);
        $ifdef = "#ifdef LDLANG_" . uc($1 . $2);
        $name = "HelpText$p";
    } else {
        die;
    }

    print <<EOT;
$ifdef
char *$name\[] = {
EOT

    open(IN, $manual) or die;
    while(<IN>) {
        chomp;
        s/\\/\\\\/g;
        s/"/\\"/g;

        print qq{    "$_",\n};
    }
    close IN;

    print <<EOT;
    NULL
};
#endif

EOT

}
