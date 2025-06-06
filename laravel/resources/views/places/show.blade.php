@extends('places.layout')
  
@section('content')

<div class="card mt-5">
  <h2 class="card-header">Show Place</h2>
  <div class="card-body">
  
    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
        <a class="btn btn-primary btn-sm" href="{{ route('places.index') }}"><i class="fa fa-arrow-left"></i> Back</a>
    </div>
  
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12">
            <div class="form-group">
                <strong>User ID:</strong> <br/>
                {{ $place->user_id }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12">
            <div class="form-group">
                <strong>Residence:</strong> <br/>
                {{ $place->residence }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12 mt-2">
            <div class="form-group">
                <strong>Block:</strong> <br/>
                {{ $place->block }}
            </div>
        </div>
    </div>
  
  </div>
</div>
@endsection