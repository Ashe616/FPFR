classdef WeightedRegression
    properties
        x;                  %输入数据的x
        y;                  %输入数据的y
        noRobustWeight;     %没使用鲁棒的权值
        w;                  %回归计算的权值
        A;                  %方程组的系数矩阵
        B;                  %方程组的右边项
        X;                  %方程组的解
        degree;             %回归方程的次数(拟合多项式的次数)
        aimIndexOriginal;   %预测点的原始下标
        py;                 %所有的预测值
        aimValue;           %预测点的预测值
        useRobust;          %是否使用鲁棒权值
        robustWeight;       %鲁棒权值
        residual;           %回归残差
    end
    
    methods
        function obj = WeightedRegression(x, y, degree, aimIndexOriginal, robustWeight)
            meanX = mean([x, aimIndexOriginal]);
            if size(x, 2) == 1
                obj.x = x - meanX;
            else
                obj.x = x' - meanX;
            end
            if size(y, 2) == 1
                obj.y = y;
            else
                obj.y = y';
            end
            obj.degree = degree;
            obj.aimIndexOriginal = aimIndexOriginal - meanX;
            if size(robustWeight, 2) == 1
                obj.robustWeight = robustWeight;
            else
                obj.robustWeight = robustWeight';
            end
            obj = obj.ComputeWeight();
            obj.w = obj.noRobustWeight .* obj.robustWeight;
            if obj.degree == 1
                obj = obj.Regression1();
            elseif obj.degree == 2
                obj = obj.Regression2();
            end
            obj = obj.Predict();
            return
        end
        
        function obj = ComputeWeight(obj)
            tempArray = (obj.aimIndexOriginal - obj.x) / max(abs(obj.aimIndexOriginal - obj.x));
            obj.noRobustWeight = (1 - abs(tempArray) .^ 3) .^ 3;
            return
        end
        
        function obj = Regression1(obj)
            obj.A = zeros(2,2);
            obj.B = zeros(2,1);
            obj.A(1,1) = sum(obj.w);
            obj.A(1,2) = sum(obj.w .* obj.x);
            obj.A(2,1) = sum(obj.w .* obj.x);
            obj.A(2,2) = sum(obj.w .* obj.x .* obj.x);
            obj.B(1,1) = sum(obj.w .* obj.y);
            obj.B(2,1) = sum(obj.w .* obj.x .* obj.y);
            obj.X = obj.A \ obj.B;
            return
        end
        
        function obj = Regression2(obj)
            obj.A = zeros(3,3);
            obj.B = zeros(3,1);
            obj.A(1,1) = sum(obj.w);
            obj.A(1,2) = sum(obj.w .* obj.x);
            obj.A(1,3) = sum(obj.w .* (obj.x .^ 2));
            obj.A(2,1) = sum(obj.w .* obj.x);
            obj.A(2,2) = sum(obj.w .* obj.x .* obj.x);
            obj.A(2,3) = sum(obj.w .* obj.x .* (obj.x .^ 2));
            obj.A(3,1) = sum(obj.w .* (obj.x .^ 2));
            obj.A(3,2) = sum(obj.w .* obj.x .* (obj.x .^ 2));
            obj.A(3,3) = sum(obj.w .* (obj.x .^ 2) .* (obj.x .^ 2));
            obj.B(1,1) = sum(obj.w .* obj.y);
            obj.B(2,1) = sum(obj.w .* obj.x .* obj.y);
            obj.B(3,1) = sum(obj.w .* (obj.x .^ 2) .* obj.y);

            obj.X = obj.A \ obj.B;
            return
        end
        
        function obj = Predict(obj)
            if obj.degree == 1
                obj.py = obj.X(1) + obj.X(2) * obj.x;
                obj.aimValue = obj.X(1) + obj.X(2) * obj.aimIndexOriginal;
            elseif obj.degree == 2
                obj.py = obj.X(1) + obj.X(2) * obj.x + obj.X(3) * (obj.x .^ 2);
                obj.aimValue = obj.X(1) + obj.X(2) * obj.aimIndexOriginal + obj.X(3) * (obj.aimIndexOriginal .^ 2);
            end
            obj.residual = obj.y - obj.py;
            return
        end
    end
end