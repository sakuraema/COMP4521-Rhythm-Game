using System;
using UnityEngine;
using UnityEngine.Events;

[Serializable] public class CoordinatesEvent : UnityEvent<Transform, Vector3, Quaternion> { }
