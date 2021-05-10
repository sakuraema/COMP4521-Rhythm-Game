using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LongPress : Bar
{
	public bool triggered;
	public bool pressing = true;

	public float pressedPosition;
	public float releasedPosition;

	private Vector3 m_StartPosition;
	private Vector3 m_EndPosition;
	private float m_Length;

	public Vector3 StartPosition { get => m_StartPosition; set => m_StartPosition = value; }
	public Vector3 EndPosition { get => m_EndPosition; set => m_EndPosition = value; }
	public float Length { get => m_Length; set => m_Length = value; }

	protected virtual void Awake()
	{
		m_Length = transform.lossyScale.z;
	}

	protected override void FixedUpdate()
	{
		if (transform.position.z <= -Length - 10f && !played)
		{
			played = true;
			Destroy(gameObject);
			//Debug.Log("Arrived at " + Time.time);
		}
	}
}
