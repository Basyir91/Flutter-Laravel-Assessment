@extends('attendances.layout')
    
@section('content')
  
<div class="card mt-5">
  <h2 class="card-header">Edit Attendance</h2>
  <div class="card-body">
  
    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
        <a class="btn btn-primary btn-sm" href="{{ route('attendances.index') }}"><i class="fa fa-arrow-left"></i> Back</a>
    </div>
  
    <form action="{{ route('attendances.update',$attendance->id) }}" method="POST">
        @csrf
        @method('PUT')
  
        <div class="mb-3">
            <label for="inputUserId" class="form-label"><strong>User ID:</strong></label>
            <input 
                type="text" 
                name="user_id" 
                value="{{ $attendance->user_id }}"
                class="form-control @error('user_id') is-invalid @enderror" 
                id="inputUserId" 
                placeholder="User ID">
            @error('user_id')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputDate" class="form-label"><strong>Date:</strong></label>
            <input 
                type="date" 
                name="date" 
                value="{{ $attendance->date }}"
                class="form-control @error('date') is-invalid @enderror" 
                id="inputDate" 
                placeholder="Date">
            @error('date')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputPlaceId" class="form-label"><strong>Place ID:</strong></label>
            <input 
                type="text" 
                name="place_id" 
                value="{{ $attendance->place_id }}"
                class="form-control @error('place_id') is-invalid @enderror" 
                id="inputPlaceId" 
                placeholder="Place ID">
            @error('place_id')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputCheckIn" class="form-label"><strong>Check-In:</strong></label>
            <input 
                type="date" 
                name="check_in" 
                value="{{ $attendance->check_in }}"
                class="form-control @error('check_in') is-invalid @enderror" 
                id="inputCheckIn" 
                placeholder="Check-In">
            @error('check_in')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputCheckOut" class="form-label"><strong>Check-Out:</strong></label>
            <input 
                type="date" 
                name="check_out" 
                value="{{ $attendance->check_out }}"
                class="form-control @error('check_out') is-invalid @enderror" 
                id="inputCheckOut" 
                placeholder="Check-Out">
            @error('check_out')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
        <button type="submit" class="btn btn-success"><i class="fa-solid fa-floppy-disk"></i> Update</button>
    </form>
  
  </div>
</div>
@endsection