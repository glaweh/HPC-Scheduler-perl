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
