<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\View\View;
use App\Http\Requests\AttendanceStoreRequest;
use App\Http\Requests\AttendanceUpdateRequest;

class AttendanceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $attendances = Attendance::latest()->paginate(5);
          
        return view('attendances.index', compact('attendances'))
                    ->with('i', (request()->input('page', 1) - 1) * 5);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('attendances.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(AttendanceStoreRequest $request): RedirectResponse
    {   
        Attendance::create($request->validated());
           
        return redirect()->route('attendances.index')
                         ->with('success', 'Attendance created successfully.');
    }

    /**
     * Display the specified resource.
     */
    public function show(Attendance $attendance): View
    {
        return view('attendances.show',compact('attendance'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Attendance $attendance): View
    {
        return view('attendances.edit',compact('attendance'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(AttendanceUpdateRequest $request, Attendance $attendance): RedirectResponse
    {
        $attendance->update($request->validated());
          
        return redirect()->route('attendances.index')
                        ->with('success','Attendance updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Attendance $attendance): RedirectResponse
    {
        $attendance->delete();
           
        return redirect()->route('attendances.index')
                        ->with('success','Attendance deleted successfully');
    }
}
