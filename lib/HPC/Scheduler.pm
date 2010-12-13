# Common interface to Batch/Cluster schedulers
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
package HPC::Scheduler;
use strict;
use warnings;
use Carp;
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
	croak "cannot update job list" unless $self->update();
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
