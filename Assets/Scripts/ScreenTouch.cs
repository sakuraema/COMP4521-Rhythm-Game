using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenTouch : MonoBehaviour
{
	public ParticleSystem touchEffect;

	private Vector3 m_touchPosition;
	private List<Poolable> m_ActiveTouchEffects = new List<Poolable>();

	// Update is called once per frame
	void Update()
    {
		//foreach (Touch touch in Input.touches)
		//{
		//	if (touch.phase == TouchPhase.Began)
		//	{
		//		// Construct a ray from the current touch coordinates
		//		Ray ray = Camera.main.ScreenPointToRay(touch.position);
		//		if (Physics.Raycast(ray))
		//		{
		//			// Create a particle if hit
		//			Instantiate(touchEffect, transform.position, transform.rotation);
		//		}
		//	}
		//}

		if (Input.GetMouseButtonDown(0))
		{
			m_touchPosition = GetComponent<Camera>().ScreenToWorldPoint(Input.mousePosition);
			m_touchPosition.z = 0;
			//touchEffect.transform.position = m_touchPosition;
			//touchEffect.Play();

			var poolable = PoolManager.instance.GetPoolable(touchEffect.GetComponent<Poolable>());
			poolable.transform.position = m_touchPosition;
			poolable.gameObject.SetActive(true);
			poolable.GetComponent<ParticleSystem>().Play();
			m_ActiveTouchEffects.Add(poolable);
		}

		for (int i = m_ActiveTouchEffects.Count - 1; i >= 0; i--)
		{
			var item = m_ActiveTouchEffects[i];
			if (item.GetComponent<ParticleSystem>().isStopped)
			{
				m_ActiveTouchEffects.Remove(item);
				PoolManager.instance.ReturnPoolable(item);
			}
		}
	}
}
