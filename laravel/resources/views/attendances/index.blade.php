@extends('attendances.layout')

@section('content')
  
<div class="card mt-5">
  <h2 class="card-header">Laravel 11 CRUD - Attendance Table</h2>
  <div class="card-body">
          
        @session('success')
            <div class="alert alert-success" role="alert"> {{ $value }} </div>
        @endsession
  
        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <a class="btn btn-success btn-sm" href="{{ route('attendances.create') }}"> <i class="fa fa-plus"></i> Create New Attendance</a>
        </div>
  
        <table class="table table-bordered table-striped mt-4">
            <thead>
                <tr>
                    <th width="80px">No</th>
                    <th>User ID</th>
                    <th>Date</th>
                    <th>Place ID</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th width="250px">Action</th>
                </tr>
            </thead>
  
            <tbody>
            @forelse ($attendances as $attendance)
                <tr>
                    <td>{{ ++$i }}</td>
                    <td>{{ $attendance->user_id }}</td>
                    <td>{{ $attendance->date }}</td>
                    <td>{{ $attendance->place_id }}</td>
                    <td>{{ $attendance->check_in }}</td>
                    <td>{{ $attendance->check_out }}</td>
                    <td>
                        <form action="{{ route('attendances.destroy',$attendance->id) }}" method="POST">
             
                            <a class="btn btn-info btn-sm" href="{{ route('attendances.show',$attendance->id) }}"><i class="fa-solid fa-list"></i> Show</a>
              
                            <a class="btn btn-primary btn-sm" href="{{ route('attendances.edit',$attendance->id) }}"><i class="fa-solid fa-pen-to-square"></i> Edit</a>
             
                            @csrf
                            @method('DELETE')
                
                            <button type="submit" class="btn btn-danger btn-sm"><i class="fa-solid fa-trash"></i> Delete</button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="7">There are no data.</td>
                </tr>
            @endforelse
            </tbody>
  
        </table>
        
        {!! $attendances->links() !!}
  
  </div>
</div>  

@endsection