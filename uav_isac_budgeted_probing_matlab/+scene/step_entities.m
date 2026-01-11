function [state, scene] = step_entities(state, scene, cfg, dt)
%STEP_ENTITIES Simple CV model with boundary reflection
area = scene.area_xy;
K = scene.K_uav;

state.uav.pos = state.uav.pos + state.uav.vel * dt;
for k = 1:K
    for d = 1:2
        if state.uav.pos(k,d) < 0
            state.uav.pos(k,d) = 0;
            state.uav.vel(k,d) = -state.uav.vel(k,d);
        elseif state.uav.pos(k,d) > area(d)
            state.uav.pos(k,d) = area(d);
            state.uav.vel(k,d) = -state.uav.vel(k,d);
        end
    end
end

if scene.bs_mobile
    state.bs.pos = state.bs.pos + state.bs.vel * dt;
    for d = 1:2
        if state.bs.pos(d) < 0
            state.bs.pos(d) = 0;
            state.bs.vel(d) = -state.bs.vel(d);
        elseif state.bs.pos(d) > area(d)
            state.bs.pos(d) = area(d);
            state.bs.vel(d) = -state.bs.vel(d);
        end
    end
end

state.t = state.t + dt;
end
