@extends('places.layout')
    
@section('content')
  
<div class="card mt-5">
  <h2 class="card-header">Add New Place</h2>
  <div class="card-body">
  
    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
        <a class="btn btn-primary btn-sm" href="{{ route('places.index') }}"><i class="fa fa-arrow-left"></i> Back</a>
    </div>
  
    <form action="{{ route('places.store') }}" method="POST">
        @csrf

          <div class="mb-3">
            <label for="inputUserId" class="form-label"><strong>User ID:</strong></label>
            <input 
                type="text" 
                name="user_id" 
                class="form-control @error('userId') is-invalid @enderror" 
                id="inputUserId" 
                placeholder="User ID">
            @error('user_id')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="inputResidence" class="form-label"><strong>Residence:</strong></label>
            <input 
                type="text" 
                name="residence" 
                class="form-control @error('residence') is-invalid @enderror" 
                id="inputResidence" 
                placeholder="Residence">
            @error('residence')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputBlock" class="form-label"><strong>Block:</strong></label>
            <input 
                type="text" 
                name="block" 
                class="form-control @error('block') is-invalid @enderror" 
                id="inputBlock" 
                placeholder="Block">
            @error('block')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <button type="submit" class="btn btn-success"><i class="fa-solid fa-floppy-disk"></i> Submit</button>
    </form>
  
  </div>
</div>
@endsection