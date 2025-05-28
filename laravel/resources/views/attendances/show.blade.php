@extends('attendances.layout')
  
@section('content')

<div class="card mt-5">
  <h2 class="card-header">Show Attendance</h2>
  <div class="card-body">
  
    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
        <a class="btn btn-primary btn-sm" href="{{ route('attendances.index') }}"><i class="fa fa-arrow-left"></i> Back</a>
    </div>
  
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12">
            <div class="form-group">
                <strong>User ID:</strong> <br/>
                {{ $attendance->user_id }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12 mt-2">
            <div class="form-group">
                <strong>Date:</strong> <br/>
                {{ $attendance->date }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12 mt-2">
            <div class="form-group">
                <strong>Place ID:</strong> <br/>
                {{ $attendance->place_id }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12 mt-2">
            <div class="form-group">
                <strong>Check-in:</strong> <br/>
                {{ $attendance->check_in }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12 mt-2">
            <div class="form-group">
                <strong>Check-out:</strong> <br/>
                {{ $attendance->check_out }}
            </div>
        </div>
    </div>
  
  </div>
</div>
@endsection