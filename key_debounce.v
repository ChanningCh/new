// 按键消抖module
// 四个按键消抖
module key_debounce (
    input sys_clk, //50M
    input sys_rstn,
    input [3:0] key_in, //低有效
    output reg [3:0] key_out,
    output [3:0] key_changed_flags //增加一个输出变化标志位
);
    parameter DEBOUCNE_COUNT = 20'd1_000_000; //按20ms计算

    wire key_csn;
    wire key_neg;
    wire key_pos;
    reg [1:0] key_reg;

    assign key_csn = key_in[0] & key_in[1] & key_in[2] & key_in[3]; //其中一个变化(按下变0, 抬起变1), 就会导致key_csn 变化, 但此处不反映变化, 只代表可以检测4个按键
    
    always @(posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            key_reg <= 2'b1;;
        end
        else begin
            key_reg <= {key_reg[1],key_csn};
        end
    end

    assign key_neg = key_reg[1] & ~key_reg[0];
    assign key_pos = ~key_reg[1] & key_reg[0];

    reg [19:0] debounce_count_reg;

    always @(posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            debounce_count_reg <= 'b0;
        end
        else begin
            if(key_neg || key_pos) begin
                debounce_count_reg <= 'b0;
            end
            else if (DEBOUCNE_COUNT -1 == debounce_count_reg) begin
                debounce_count_reg <= 'b0;
            end
            else begin
                debounce_count_reg <= debounce_count_reg + 1'b1;
            end
        end
    end

    // 第一种写法: 使用组合逻辑, assign 输出 此方法缺点, 在assign 中无法给reg赋值, 只能再加一个时序逻辑, 而且key_out_wire缺省值不确定
    wire [3:0] key_out_wire;
    assign key_out_wire = (DEBOUCNE_COUNT == debounce_count_reg)?key_in:1; //不赋值会保持之前的状态
    always @(posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            key_out <= 4'b1111;
        end
        else begin
            key_out <= key_out_wire;
        end
    end

    // 第二种写法: 使用组合逻辑
    reg [3:0] key_out_reg[1:0]; 
    always @(posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            key_out_reg[0] <= 4'b1111;
            key_out_reg[1] <= 4'b1111;
        end
        else begin
            key_out_reg[1] <= key_out_reg[0]; //先保存上一状态值, 再赋值, 注意if 中的先后顺序
            if (DEBOUCNE_COUNT == debounce_count_reg) begin
                key_out_reg[0] <= key_in;
            end
            else;
        end
    end

    always @(posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            key_out <= 4'b1111;
        end
        else begin
            key_out <= key_out_reg[1];
        end
    end
    
    assign key_changed_flags = key_out_reg[1] & ~key_out_reg[0];

endmodule