#!/usr/bin/env perl

#****************************************************************************
#*   Super Pi Power!                                                        *
#*   Turn outlets on and off from a webui running on the Pi!                *
#*                                                                          *
#*   Copyright (C) 2013 by Jeremy Falling except where noted.               *
#*                                                                          *
#*   This program is free software: you can redistribute it and/or modify   *
#*   it under the terms of the GNU General Public License as published by   *
#*   the Free Software Foundation, either version 3 of the License, or      *
#*   (at your option) any later version.                                    *
#*                                                                          *
#*   This program is distributed in the hope that it will be useful,        *
#*   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
#*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
#*   GNU General Public License for more details.                           *
#*                                                                          *
#*   You should have received a copy of the GNU General Public License      *
#*   along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
#****************************************************************************

use strict;
use warnings;

#############################################################################
###Start user options

#Define pins in order, so the first item in the array is outlet 1, second item is outlet 2, etc
#I don't do any sanity checking for this, so get it right ;-)
my @outlets = ('23', '24');

#If your relay is set to NC, use 1, if NO, use 0
my $mode = 1;

#Are you using https? Are you behind an https proxy? Then set this to true
my $https = "false";


### End user options  (**STOP EDITING!**)
#############################################################################



my $progamName = "Super Pi Power!";
my $version = "1.1";

my ($on, $off, $reqPin, $curPin, $currentStatus, $junk, $url);
my ( $buffer, @pairs, $pair, $name, $value, %FORM);

# Read in text from post
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "POST")
{
	read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
}
else {
	$buffer = $ENV{'QUERY_STRING'};
}

# Split information into name/value pairs
@pairs = split(/&/, $buffer);
foreach $pair (@pairs)
{
	($name, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%(..)/pack("C", hex($1))/eg;
	$FORM{$name} = $value;
}

#store the requested outlet and action
my $outlet = $FORM{outlet};
my $action = $FORM{action};

#To prevent errors, make outlet=0 if not defined (since 0 is not a valid outlet)
if (!defined $outlet) {$outlet = "0";}

#get the number of outlets in the array
my $numOfOutlets = $#outlets + 1;

#if a post was made, get the gpio pin for the requested outlet
if ($ENV{'REQUEST_METHOD'} eq "POST")
{
	$reqPin = $outlet - 1;
	$curPin = $outlets[$reqPin];
	
	#Setup current pin. What we do here is see if folder for the pin exists. If it does not then the pin has not been set up.
	unless (-e "/sys/class/gpio/gpio$curPin") {
		system("sudo bash -c 'echo \"$curPin\" > /sys/class/gpio/export'");
		system("sudo bash -c 'echo \"out\" > /sys/class/gpio/gpio$curPin/direction'");
	} 
	
}

#get url
if ($https eq "true") {
$url="https://$ENV{'HTTP_HOST'}$ENV{'REQUEST_URI'}";
}
else {
$url="http://$ENV{'HTTP_HOST'}$ENV{'REQUEST_URI'}";
}


#Check to see what the mode is, and set on/off values accordingly
if ($mode == 1){
	$on = 0;
	$off = 1;
}

else{
	$on = 1;
	$off = 0;
}

#Send some headers
print "Content-type:text/html\r\n\r\n";
print '<!DOCTYPE HTML SYSTEM>' . "\n";
print '<html>' . "\n";
print '<head>' . "\n";
print '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n";
print '<title>Super Pi Power!</title>' . "\n";
print '</head>' . "\n";
print '<body>' . "\n";
print '<center>' . "\n";
print '<h1>Super Pi Power!</h1> <hr width="260px">' . "\n";

#Check if we are processing a post, if not then don't print action preformed or attempt to do anything
if ($ENV{'REQUEST_METHOD'} eq "POST")
{    
	print "Action preformed: Outlet: $outlet Action: $action <br>";
	
	#preform sanity check
	if ($outlet <= 0 or $outlet > $numOfOutlets )
	{
		print "ERROR: Outlet $outlet is not within valid range";
	}

	else
	{
		#check if status was requested, if so get the status of outlet
		if ($action eq "status")
		{ 
			$currentStatus = `cat /sys/class/gpio/gpio$curPin/value`;
			print "Current status of outlet $outlet: ";
			if ($currentStatus == $on) 
			{
			print "ON";
			}
			else
			{
			print "OFF";
			}
		}
		elsif ($action eq "on")
		{ 
			$currentStatus = `sudo bash -c 'echo "$on" > /sys/class/gpio/gpio$curPin/value'`;
		}
		elsif ($action eq "off")
		{ 
			$currentStatus = `sudo bash -c 'echo "$off" > /sys/class/gpio/gpio$curPin/value'`;
		}
		else
                {
<<<<<<< HEAD
                        print 'ERROR: Invalid action requested<br>';
=======
			print 'ERROR: Invalid action requested<br>';
>>>>>>> v1.1
                }
	}
}
print "<form name=\"powerAction\" action=\"$url\" method=\"POST\">" . "\n";
print '<br>';

#Auto generate the outlet options
for ($numOfOutlets)
{
	my $i = 1;
	my $max = $numOfOutlets + 1;

	while ($i < $max)
	{
<<<<<<< HEAD
		print "<input type=\"radio\" name=\"outlet\" value=\"$i\"> Outlet $i<br>";
=======
		print "<input type=\"radio\" name=\"outlet\" value=\"$i\"";
		#If an action was requested for this outlet id, print checked.  
		if ( $i == $outlet) {print "checked";}
		print "> Outlet $i<br>" . "\n";
>>>>>>> v1.1
		$i++;
	}

}

print '<br><button type="submit" name="action" value="on">On</button> '. "\n";
print '<button type="submit" name="action" value="off">Off</button> '. "\n";
print '<button type="submit" name="action" value="status">Status</button>' . "\n";
print '</form>'. "\n";
print "</center>\n";
print "<br><br><br>\n";
print "<i>Version: $version on: $ENV{'HTTP_HOST'} running: $ENV{SERVER_SOFTWARE}</i> <br>" . "\n";
print "<a href=\"$url\">Reset page</a>";

print "</body>\n";
print "</html>";


1;

