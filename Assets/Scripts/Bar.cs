using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bar : MonoBehaviour
{
	public AudioClip clap;

	private AudioSource audioSource;
	private bool played;

    private void Start()
	{
		audioSource = GetComponent<AudioSource>();
    }


	public void Reset()
	{
		played = false;
	}

	// Update is called once per frame
	void FixedUpdate()
    {
        if (transform.position.z <= 0 && !played)
		{
			audioSource.PlayOneShot(clap);
			played = true;
		}
    }
}
