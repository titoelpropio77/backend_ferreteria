<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use Illuminate\Http\Request;

class EmployeeController extends Controller
{
    public function index() { return Employee::all(); }
    public function store(Request $request) { return Employee::create($request->all()); }
    public function show(Employee $employee) { return $employee; }
    public function update(Request $request, Employee $employee) { $employee->update($request->all()); return $employee; }
    public function destroy(Employee $employee) { $employee->delete(); return response()->noContent(); }
}
