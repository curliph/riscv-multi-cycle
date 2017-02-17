
//
// RISCV multi-cycle implementation.
//
// Module:      rvm_control
//
// Description: Contains the main control FSM for the core.
//
//

`include "rvm_constants.v"

module rvm_control(
input  wire         clk        , // System level clock.
input  wire         resetn     , // Asynchronous active low reset.
{% for interface_name in interfaces %}
{% set interface = interfaces[interface_name]  %}
// Interface: {{interface_name}}
    {% for signal_name  in interface.signals -%}
    {% set signal = interface.signals[signal_name] -%}
{{signal.direction()}} [{{signal.get_range()}}] {{signal.verilog_name()}}
    {%- if not loop.last -%},{% endif %}
    {% endfor -%}
{%- if not loop.last -%},{%- endif -%}
{% endfor %}

);

//-----------------------------------------------------------------------------
// State variable encodings.
//-----------------------------------------------------------------------------

{% for state in states %}
localparam {{states[state].verilog_name()}} = {{loop.index0}};
{%- endfor %}

//
// Holders for the current and next states.
reg [{{state_var_w}}:0] {{state_var}};
reg [{{state_var_w}}:0] n_{{state_var}};

//-----------------------------------------------------------------------------

{% for interface_name in interfaces %}
{% set interface = interfaces[interface_name]  %}

//-----------------------------------------------------------------------------
// Signal assignments for the {{interface_name}} interface.
//-----------------------------------------------------------------------------

    {% for signal_name  in interface.signals -%}
    {% set signal = interface.signals[signal_name] -%}

assign {{signal_name}} = {{signal.set_expression()}};
    
    {% endfor -%}
{% endfor %}

//-----------------------------------------------------------------------------

//
// process: p_ctrl_next_state
//
//      Responsible for computing the next state of the core given the
//      current state.
//
always @(*) begin : p_ctrl_next_state
case ({{state_var}})

{%- for state_name in states %}
{% set state = states[state_name] %}
    {{state.verilog_name()}}: begin
        n_{{state_var}} = {{state.next_state_expression()}};
    end
{%- endfor %}

    default:
        n_{{state_var}} = {{default_next_state}};

endcase end


//
// process: p_ctrl_progress_state
//
//      Responsible for moving to the next state
//
always @(posedge clk, negedge resetn) begin : p_ctrl_progress_state

    // STATE PROGRESSION //

end

endmodule
