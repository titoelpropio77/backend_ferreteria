<?php

namespace Tests\Feature;

use App\Models\Employee;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class EmployeeTest extends TestCase
{
    use RefreshDatabase;
    /**
     *
     *
     */
    public function test_it_validate_response_product(): void
    {
        Employee::factory()->create();
        $response = $this->get('api/clients');
        $response->assertStatus(200);
    }


    public function test_it_validate_create_product(): void
    {
        $employee =  Employee::factory()->make();
        $response = $this->post('api/employees', $employee->toArray());
        $response->assertStatus(201);
        $this->assertDatabaseHas('employees', $employee->toArray());
    }
}
