# Lowlevel BatchJob::Scheduler interface to Grid Engine
# Copyright (C) 2010 Henning Glawe <glaweh@debian.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
package HPC::Scheduler::GridEngine;
use strict;
use warnings;
use HPC::Scheduler;
@HPC::Scheduler::GridEngine::ISA=('HPC::Scheduler');
my %ge_states_map=(
	Rr  => 'running',
	r   => 'running',
	qw  => 'queued',
	Eqw => 'error',
	hqw => 'queued',
);
sub new {
	my $class=shift;
	my $options=shift;
	my $self=$class->SUPER::new($options);
	bless($self,$class);
	return($self);
}
sub update {
	my $self=shift;
	my $qstat;
	if (defined $self->{SIMULATION}) {
		return(undef) unless (open($qstat,'<',$self->{SIMULATION}));
	} else {
		return(undef) unless (open($qstat,'-|','qstat'));
	}
	my %job_state;
	while (<$qstat>) {
		chomp;
		next unless (/^\s*(\d+)\s+/);
		my $jid=$1;
		my @l=split;
		$job_state{$jid}=(exists $ge_states_map{$l[4]} ? $ge_states_map{$l[4]} : 'unknown');
	}
	close($qstat);
	$self->SUPER::update(\%job_state);
	return($self);
}
1;
