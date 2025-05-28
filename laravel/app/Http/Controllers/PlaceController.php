<?php

namespace App\Http\Controllers;

use App\Models\Place;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\View\View;
use App\Http\Requests\PlaceStoreRequest;
use App\Http\Requests\PlaceUpdateRequest;

class PlaceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $places = Place::latest()->paginate(5);
          
        return view('places.index', compact('places'))
                    ->with('i', (request()->input('page', 1) - 1) * 5);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('places.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(PlaceStoreRequest $request): RedirectResponse
    {   
        Place::create($request->validated());
           
        return redirect()->route('places.index')
                         ->with('success', 'Place created successfully.');
    }

    /**
     * Display the specified resource.
     */
    public function show(Place $place): View
    {
        return view('places.show',compact('place'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Place $place): View
    {
        return view('places.edit',compact('place'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(PlaceUpdateRequest $request, Place $place): RedirectResponse
    {
        $place->update($request->validated());
          
        return redirect()->route('places.index')
                        ->with('success','Place updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Place $place): RedirectResponse
    {
        $place->delete();
           
        return redirect()->route('places.index')
                        ->with('success','Place deleted successfully');
    }
}
