using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;

public class TestScroller : Singleton<TestScroller>
{
	static readonly private float BEAT_INTERVAL = 4f;

	public float bgm = 128;
	[Range(0, 10)]
	public float speedMultiplier = 1;

	private Vector3 m_Velocity;
	private float m_Speed;

	public float Speed { get => m_Speed; set => m_Speed = value; }

	protected override void Awake()
	{
		base.Awake();
		m_Speed = BEAT_INTERVAL * speedMultiplier / (60 / bgm);
		m_Velocity = new Vector3(0f, 0f, -m_Speed);

		// Scaling according to speed
		float scaleZ = speedMultiplier;
		transform.localScale = new Vector3(1, 1, scaleZ);
		foreach (Transform child in transform)
		{
			child.localScale = new Vector3(child.localScale.x, child.localScale.y, child.localScale.z / scaleZ);
		}
	}

	private void Update()
	{
		transform.position += m_Velocity * Time.deltaTime;
	}

	private void OnDrawGizmos()
	{
		
	}
}
