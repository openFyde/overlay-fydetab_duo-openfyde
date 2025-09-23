// Copyright 2012 The ChromiumOS Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include <map>

#include <gtest/gtest.h>  // For FRIEND_TEST

#include "include/filter_interpreter.h"
#include "include/finger_metrics.h"
#include "include/gestures.h"
#include "include/prop_registry.h"
#include "include/tracer.h"

#ifndef GESTURES_DISTANCE_FILTER_INTERPRETER_H_
#define GESTURES_DISTANCE_FILTER_INTERPRETER_H_

namespace gestures {

// This filter interpreter suppresses fingers that move too far between frames.
// This provides simple distance-based suppression to catch obvious sensor
// errors and large jumps.

class DistanceFilterInterpreter : public FilterInterpreter,
                                  public PropertyDelegate {
  FRIEND_TEST(DistanceFilterInterpreterTest, SimpleTest);
 public:
  // Takes ownership of |next|:
  DistanceFilterInterpreter(PropRegistry* prop_reg, Interpreter* next,
                           Tracer* tracer);
  virtual ~DistanceFilterInterpreter() {}

 protected:
  virtual void SyncInterpretImpl(HardwareState& hwstate, stime_t* timeout);

 private:
  // Fingers from the previous SyncInterpret call
  std::map<short, FingerState> previous_input_;

  // Whether or not this filter is enabled. If disabled, it behaves as a
  // simple passthrough.
  BoolProperty enabled_;

  // Maximum distance a finger can move between frames before being flagged
  // as a teleportation warp. This provides simple distance-based suppression.
  DoubleProperty max_frame_distance_;
};

}  // namespace gestures

#endif  // GESTURES_DISTANCE_FILTER_INTERPRETER_H_