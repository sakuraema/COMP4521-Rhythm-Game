using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bar : MonoBehaviour
{
	public AudioClip clap;

	private AudioSource audioSource;
	private bool played;

    protected virtual void Start()
	{
		audioSource = GetComponent<AudioSource>();
    }


	public virtual void Reset()
	{
		played = false;
	}

	// Update is called once per frame
	protected virtual void FixedUpdate()
    {
        if (transform.position.z <= -15 && !played)
		{
			played = true;
			Destroy(gameObject);
			//Debug.Log("Arrived at " + Time.time);
		}
    }
}
