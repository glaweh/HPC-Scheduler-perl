package HPC::Scheduler;
use strict;
use warnings;
our @job_states=('running','queued','error','not_queued','unknown');
sub new {
	my $class=shift;
	my $options=shift;
	my $self={};
	$self->{SIMULATION}=undef;
	$self->{JOBS}={};
	if (defined $options) {
		while (my ($opt,$val)=each(%{$options})) {
			$self->{$opt}=$val;
		}
	}
	bless($self,$class);
	$self->update();
	return($self);
}
sub update {
	my $self=shift;
	my $job_state=shift;
	if (defined $job_state) {
		foreach (keys %{$self->{JOBS}}) {
			delete $self->{JOBS}->{$_} unless (exists $job_state->{$_});
		}
		while (my ($key,$val)=each(%{$job_state})) {
			$self->{JOBS}->{$key}=$val;
		}
	}
	return($self);
}
sub check_job {
	my $self=shift;
	my $job_id=shift;
	return(-1,'not_submitted') unless (defined $job_id);
	if (exists $self->{JOBS}->{$job_id}) {
		return($job_id,$self->{JOBS}->{$job_id});
	} else {
		return($job_id,'not_queued');
	}
}
1;
