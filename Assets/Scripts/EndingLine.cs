using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndingLine : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        foreach (Transform child in transform)
		{
			child.GetComponent<BoxCollider>().size = new Vector3(0.1f, 0.5f, Scroller.instance.speed / 2f);
		}
    }
}
