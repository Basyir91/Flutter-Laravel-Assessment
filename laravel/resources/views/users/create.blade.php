@extends('users.layout')
    
@section('content')
  
<div class="card mt-5">
  <h2 class="card-header">Add New User</h2>
  <div class="card-body">
  
    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
        <a class="btn btn-primary btn-sm" href="{{ route('users.index') }}"><i class="fa fa-arrow-left"></i> Back</a>
    </div>
  
    <form action="{{ route('users.store') }}" method="POST">
        @csrf
  
        <div class="mb-3">
            <label for="inputName" class="form-label"><strong>Name:</strong></label>
            <input 
                type="text" 
                name="name" 
                class="form-control @error('name') is-invalid @enderror" 
                id="inputName" 
                placeholder="Name">
            @error('name')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputAge" class="form-label"><strong>Age:</strong></label>
            <input 
                type="text" 
                name="age" 
                class="form-control @error('name') is-invalid @enderror" 
                id="inputAge" 
                placeholder="Age">
            @error('age')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputEmail" class="form-label"><strong>Email:</strong></label>
            <input 
                type="text" 
                name="email" 
                class="form-control @error('email') is-invalid @enderror" 
                id="inputEmail" 
                placeholder="Email">
            @error('email')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
  
        <div class="mb-3">
            <label for="inputPassword" class="form-label"><strong>Password:</strong></label>
            <input 
                type="text" 
                name="password" 
                class="form-control @error('password') is-invalid @enderror" 
                id="inputPassword" 
                placeholder="Password">
            @error('password')
                <div class="form-text text-danger">{{ $message }}</div>
            @enderror
        </div>
        <button type="submit" class="btn btn-success"><i class="fa-solid fa-floppy-disk"></i> Submit</button>
    </form>
  
  </div>
</div>
@endsection