using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bar : MonoBehaviour
{
	public AudioClip clap;

	private AudioSource audioSource;
	private bool played;

    private bool m_CanBePressed;
    private float m_EffectiveDistance, m_perfectDistance;
	
    private void Start()
	{
		audioSource = GetComponent<AudioSource>();
        m_EffectiveDistance = GameObject.Find("Scroller").GetComponent<Scroller>().speed;
        m_perfectDistance = m_EffectiveDistance / 2f;
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

        if (Input.GetMouseButtonDown(0))
            if (m_CanBePressed)
            {
                float distance = Mathf.Abs(transform.position.z);
                if (distance < m_perfectDistance)
                {
                    print("Perfect");
                    gameObject.SetActive(false);
                }
                //else if (distance > m_perfectDistance && distance < m_EffectiveDistance)
                //{
                //    print("Good");
                //    gameObject.SetActive(false);
                //}
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
