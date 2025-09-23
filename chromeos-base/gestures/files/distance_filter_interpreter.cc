// Copyright 2012 The ChromiumOS Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "include/distance_filter_interpreter.h"

#include "include/tracer.h"
#include "include/util.h"

namespace gestures {

DistanceFilterInterpreter::DistanceFilterInterpreter(PropRegistry* prop_reg,
                                                     Interpreter* next,
                                                     Tracer* tracer)
    : FilterInterpreter(nullptr, next, tracer, false),
      enabled_(prop_reg, "Distance Filter Enable", false),
      max_frame_distance_(prop_reg, "Distance Filter Max Frame Distance", 5.0) {
  InitName();
}

void DistanceFilterInterpreter::SyncInterpretImpl(HardwareState& hwstate,
                                                  stime_t* timeout) {
  const char name[] = "DistanceFilterInterpreter::SyncInterpretImpl";
  LogHardwareStatePre(name, hwstate);

  if (!enabled_.val_) {
    next_->SyncInterpret(hwstate, timeout);
    return;
  }

  RemoveMissingIdsFromMap(&previous_input_, hwstate);

  for (size_t i = 0; i < hwstate.finger_cnt; i++) {
    short tracking_id = hwstate.fingers[i].tracking_id;

    // Check if we have previous frame data for this finger
    if (MapContainsKey(previous_input_, tracking_id)) {
      const FingerState& current_fs = hwstate.fingers[i];
      const FingerState& prev_fs = previous_input_[tracking_id];

      float dx = current_fs.position_x - prev_fs.position_x;
      float dy = current_fs.position_y - prev_fs.position_y;
      float distance = sqrtf(dx * dx + dy * dy);

      if (distance > max_frame_distance_.val_) {
        unsigned old_flags = hwstate.fingers[i].flags;

        hwstate.fingers[i].flags |= (GESTURES_FINGER_WARP_X_MOVE |
                                     GESTURES_FINGER_WARP_Y_MOVE |
                                     GESTURES_FINGER_WARP_X_NON_MOVE |
                                     GESTURES_FINGER_WARP_Y_NON_MOVE |
                                     GESTURES_FINGER_WARP_TELEPORTATION);

        Log("DISTANCE_SUPPRESS: finger_id=%d, distance=%.3f > max=%.3f, "
            "movement=(%.3f,%.3f), old_flags=0x%x, new_flags=0x%x",
            tracking_id, distance, max_frame_distance_.val_,
            dx, dy, old_flags, hwstate.fingers[i].flags);
      }
    }
  }

  // Update previous input state
  for (size_t i = 0; i < hwstate.finger_cnt; i++)
    previous_input_[hwstate.fingers[i].tracking_id] = hwstate.fingers[i];

  LogHardwareStatePost(name, hwstate);
  next_->SyncInterpret(hwstate, timeout);
}

}  // namespace gestures