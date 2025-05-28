@extends('places.layout')

@section('content')
  
<div class="card mt-5">
  <h2 class="card-header">Laravel 11 CRUD - Place Table</h2>
  <div class="card-body">
          
        @session('success')
            <div class="alert alert-success" role="alert"> {{ $value }} </div>
        @endsession
  
        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <a class="btn btn-success btn-sm" href="{{ route('places.create') }}"> <i class="fa fa-plus"></i> Create New Place</a>
        </div>
  
        <table class="table table-bordered table-striped mt-4">
            <thead>
                <tr>
                    <th width="80px">No</th>
                    <th>User ID</th>
                    <th>Residence</th>
                    <th>Block</th>
                    <th width="250px">Action</th>
                </tr>
            </thead>
  
            <tbody>
            @forelse ($places as $place)
                <tr>
                    <td>{{ ++$i }}</td>
                    <td>{{ $place->user_id }}</td>
                    <td>{{ $place->residence }}</td>
                    <td>{{ $place->block }}</td>
                    <td>
                        <form action="{{ route('places.destroy',$place->id) }}" method="POST">
             
                            <a class="btn btn-info btn-sm" href="{{ route('places.show',$place->id) }}"><i class="fa-solid fa-list"></i> Show</a>
              
                            <a class="btn btn-primary btn-sm" href="{{ route('places.edit',$place->id) }}"><i class="fa-solid fa-pen-to-square"></i> Edit</a>
             
                            @csrf
                            @method('DELETE')
                
                            <button type="submit" class="btn btn-danger btn-sm"><i class="fa-solid fa-trash"></i> Delete</button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="5">There are no data.</td>
                </tr>
            @endforelse
            </tbody>
  
        </table>
        
        {!! $places->links() !!}
  
  </div>
</div>  

@endsection