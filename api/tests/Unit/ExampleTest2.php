<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

class ExampleTest2 extends TestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function test_example()
    {
        $this->assertTrue(true);
        //
    }

    public function test_sum_function_success()
    {
        $a = 20;
        $b = 30;
        $this->assertEquals(50, ($a+$b));
    }

    public function test_sum_function_failure()
    {
        $a = 20;
        $b = 30;
        $this->assertNotEquals(60, ($a+$b));
    }


}
