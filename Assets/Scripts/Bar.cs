using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bar : MonoBehaviour
{
	public AudioClip clap;

	private AudioSource audioSource;
	private bool played;

    private bool m_CanBePressed;
	
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

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Activator")
        {
            m_CanBePressed = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Activator")
        {
            m_CanBePressed = false;
        }
    }
}
