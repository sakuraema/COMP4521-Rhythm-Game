using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Track : MonoBehaviour
{
	public Material original;
	public Material selected;

	protected void Update()
	{
		if (Input.GetMouseButton(0))
		{
			RaycastHit hitInfo;
			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			if (Physics.Raycast(ray, out hitInfo, 100.0f))
			{
				if (hitInfo.transform == this.transform)
				{
					GetComponent<Renderer>().material = selected;
					return;
				}
			}
		}
		GetComponent<Renderer>().material = original;
	}
}
