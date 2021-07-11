classdef WeightedRegression
    properties
        x;                  %�������ݵ�x
        y;                  %�������ݵ�y
        noRobustWeight;     %ûʹ��³����Ȩֵ
        w;                  %�ع�����Ȩֵ
        A;                  %�������ϵ������
        B;                  %��������ұ���
        X;                  %������Ľ�
        degree;             %�ع鷽�̵Ĵ���(��϶���ʽ�Ĵ���)
        aimIndexOriginal;   %Ԥ����ԭʼ�±�
        py;                 %���е�Ԥ��ֵ
        aimValue;           %Ԥ����Ԥ��ֵ
        useRobust;          %�Ƿ�ʹ��³��Ȩֵ
        robustWeight;       %³��Ȩֵ
        residual;           %�ع�в�
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